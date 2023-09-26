# This script will be used by SA team to:
# Test the following functionalities work well together:
# 1. terraform
# 2. cloud register
# 3. cloud functional verification

# Prerequisites:
# 1. (for AWS) Use the AWS credentials that you want to create resources in.
#    (for GCP) It will need your GCP credentials as you run.
# 2. Use the anyscale credentials that you want to register the cloud to.
# 3. Have terraform installed and python package python_terraform installed.
# 4. Run this script in product repo.

from datetime import datetime
import re
import subprocess
import argparse
import boto3
from google.cloud import storage
import time
from rich.progress import (
    BarColumn,
    Progress,
    SpinnerColumn,
    TextColumn,
    TimeElapsedColumn,
)
from rich.logging import RichHandler
from rich.console import Group
from rich.live import Live
import logging
from anyscale.controllers.cloud_controller import CloudController
from python_terraform import Terraform, IsFlagged, IsNotFlagged

logging.basicConfig(level=logging.INFO, format="%(message)s", handlers=[RichHandler()])
logger = logging.getLogger("rich")


# Feel free to edit the following variables for AWS
def _get_terraform_anyscale_v2_e2e_public_vars_aws():
    """Get the variables for the aws terraform apply.
    The variables are required by the terraform as input variables.
    """
    return {
        "aws_region": "us-east-2",
        "common_prefix": "e2etest-tf-",
        "customer_ingress_cidr_ranges": "0.0.0.0/0",
    }


# Feel free to edit the following variables for GCP
def _get_terraform_anyscale_v2_e2e_public_vars_gcp(
    billing_account_id: str, anyscale_org_id: str, root_folder_number: str
):
    """Get the variables for the gcp anyscale-v2-commonname terraform apply.
    The variables are required by the terraform as input variables.
    """
    return {
        "anyscale_google_region": "us-central1",
        "anyscale_google_zone": "us-central1-a",
        "anyscale_org_id": anyscale_org_id,  # Anyscale org id.
        "customer_ingress_cidr_ranges": "0.0.0.0/0",  # Suggested by the terraform.  # noqa: E501
        "root_folder_number": root_folder_number,  # This is the folder id of the folder "cloud-setup-terraform-test" in gcp.  # noqa: E501
        "billing_account_id": billing_account_id,
    }


def _terraform_init(tf: Terraform):
    """Run terraform init."""
    logger.info("Running: terraform init")
    try:
        return_code, stdout, stderr = tf.init()
        logger.info("  Succesfull: terraform init")
        return return_code, stdout, stderr
    except Exception as e:
        logger.error(f"Error running terraform init: {e}")
        raise e


def _terraform_apply(tf: Terraform, expected_time: int, variables: dict):
    """Run terraform apply."""
    logger.info(f"Running: terraform apply (approx. time: {expected_time} min)")
    try:
        return_code, stdout, stderr = tf.apply(
            skip_plan=True,
            capture_output=True,
            var=variables,
        )

        logger.info("  Succesfull: terraform apply")
        return return_code, stdout, stderr
    except Exception as e:
        logger.error(f"Terraform apply failed: {e}")
        raise e


def _terraform_destroy(tf: Terraform, variables: dict):
    """Run terraform destroy."""
    logger.info("Running: terraform destroy")
    try:
        return_code, stdout, stderr = tf.destroy(
            capture_output=True,
            auto_approve=IsFlagged,
            force=IsNotFlagged,
            var=variables,
        )

        logger.info("  Succesfull: terraform destroy")
        return return_code, stdout, stderr
    except Exception as e:
        logger.error(f"Error running terraform destroy: {e}")
        raise e


def _anyscale_cloud_delete(cloud_controller: CloudController, cloud_name: str):
    """Delete the cloud from anyscale."""
    logger.info("Running: anyscale cloud delete")
    try:
        cloud_controller.delete_cloud(
            cloud_name=cloud_name,
            cloud_id="",
            skip_confirmation=True,
        )
        logger.info("  Cloud deleted successfully")
        return 0
    except Exception as e:
        logger.info(f"Error deleting anyscale cloud: {e}")
        return 1


# def _terraform_output(tf: Terraform):
#     """Run terraform output."""
#     try:
#         return_code, stdout, stderr = tf.output(capture_output=True)
#         # result = subprocess.run(
#         #     ["terraform", "output", "-json"],
#         #     capture_output=True,
#         #     cwd=working_dir,
#         #     text=True,
#         # )
#         return return_code, stdout, stderr
#     except Exception as e:
#         logger.error(f"Error running terraform output: {e}")
#         raise e


def _parse_registration_command(input_string):
    """Parse the registration command from the terraform output."""
    pattern = r"EOT\n(.*?)EOT"
    match = re.search(pattern, input_string, re.DOTALL)
    if not match:
        return None

    registration_command = match.group(1)
    logger.debug(registration_command)
    return _parse_options(registration_command)


def _parse_options(input_string):
    """Parse the options from the registration command."""
    matches = re.findall(r"--(\S+?)\s(\S+)", input_string)
    return {key: value.strip() for key, value in matches}


def _sleep_timer(seconds: int):
    """Sleep for the given number of seconds."""
    logger.info(f"Sleeping for {seconds} seconds")
    step_task_id = step_progress.add_task(
        f"Sleeping for {seconds} seconds", total=seconds
    )
    for i in range(seconds):
        step_progress.update(step_task_id, advance=1)
        time.sleep(1)
    step_progress.stop_task(step_task_id)
    step_progress.update(step_task_id, visible=False)


def start_aws_test(branch_name: str, local_path: str):
    # If you have some error like "destination path 'terraform-aws-anyscale-cloudfoundation-modules' already exists and is not an empty directory",  # noqa: E501
    # remove the terraform-aws-anyscale-cloudfoundation-modules folder and run this script again.  # noqa: E501
    # "sudo rm -r terraform-aws-anyscale-cloudfoundation-modules"
    logger.info("Applying anyscale_v2_e2e_public aws terraform")

    if local_path:
        logger.debug("Using local path...")
    else:
        logger.info("Cloning the repo...")
        repo_url = "https://github.com/anyscale/terraform-aws-anyscale-cloudfoundation-modules/"
        subprocess.check_call(["git", "clone", repo_url])
        # Checkout to a specific branch
        subprocess.check_call(
            ["git", "checkout", branch_name],
            cwd="terraform-aws-anyscale-cloudfoundation-modules",
        )

    tf = Terraform(working_dir=local_path)

    with live:
        task_id = e2e_progress.add_task("", total=100)

        e2e_progress.update(task_id, description="Running: terraform init")
        return_code, stdout, stderr = _terraform_init(tf)
        if return_code != 0:
            raise RuntimeError(f"Error initializing terraform: {stderr}")

        e2e_progress.update(
            task_id,
            description="Running: terraform apply",
            advance=20,
        )
        return_code, stdout, stderr = _terraform_apply(
            tf,
            5,
            _get_terraform_anyscale_v2_e2e_public_vars_aws(),
        )
        if return_code != 0:
            logger.error("Error running: terraform apply")
            logger.error(stderr)
        logger.debug(stdout)

        logger.info("Applied AWS Terraform: anyscale_v2_e2e_public")

        ## Gather information for registration
        cloud_name = (
            f"test_terraform_anyscale_v2_e2e_public_aws_{datetime.now().isoformat()}"
        )
        stdout_dict = _parse_registration_command(stdout)
        s3_bucket_id = stdout_dict.get("s3-bucket-id")

        ## Register the cloud.
        e2e_progress.update(
            task_id,
            description="Registering Anyscale AWS cloud...",
            advance=40,
        )
        try:
            cloud_controller = CloudController()
            cloud_controller.register_aws_cloud(
                region=stdout_dict.get("region"),
                name=cloud_name,
                vpc_id=stdout_dict.get("vpc-id"),
                subnet_ids=stdout_dict.get("subnet-ids").split(","),
                efs_id=stdout_dict.get("efs-id"),
                anyscale_iam_role_id=stdout_dict.get("anyscale-iam-role-id"),
                instance_iam_role_id=stdout_dict.get("instance-iam-role-id"),
                security_group_ids=stdout_dict.get("security-group-ids").split(","),
                s3_bucket_id=s3_bucket_id,
                # Changed functional_verify to `None` to
                # allow Anyscale resources time to be created.
                functional_verify=None,
                private_network=False,
                cluster_management_stack_version="v2",
                memorydb_cluster_id=None,
                yes=True,
            )
            logger.info("  Cloud registered successfully")
        except Exception as e:
            logger.error(f"Error registering cloud: {e}")

        e2e_progress.update(
            task_id, description="Sleeping: Waiting for Anyscale resources", advance=30
        )
        # pause for 3 min to wait for Anyscale to be ready
        _sleep_timer(60 * 3)
        e2e_progress.update(
            task_id,
            description="Proceeding with Anyscale functional test",
            completed=100,
        )
        e2e_progress.stop_task(task_id)

    logger.info("Starting: Anyscale functional test")
    try:
        cloud_controller.verify_cloud(
            cloud_name=cloud_name,
            cloud_id=None,
            strict=True,
            # Change functional_verify="workspace,service" once service is ready.
            # Requires user confirmation to proceed or setting yes=True
            functional_verify="workspace",
            yes=True,
        )
        logger.info("  Completed: AWS Cloud verified successfully")
    except Exception as e:
        logger.error(f"Error verifying aws cloud: {e}")

    with live:
        task_id = e2e_progress.add_task("", total=100)

        ## Delete the cloud.
        e2e_progress.update(task_id, description="Deleting Anyscale AWS cloud...")
        _anyscale_cloud_delete(cloud_controller, cloud_name)

        ## Emptying the bucket.
        e2e_progress.update(
            task_id,
            description=f"Emptying bucket {s3_bucket_id}...",
            advance=30,
        )
        s3_client = boto3.client("s3")
        object_response_paginator = s3_client.get_paginator("list_object_versions")
        delete_marker_list = []
        version_list = []
        for object_response_itr in object_response_paginator.paginate(
            Bucket=s3_bucket_id
        ):
            if "DeleteMarkers" in object_response_itr:
                for delete_marker in object_response_itr["DeleteMarkers"]:
                    delete_marker_list.append(
                        {
                            "Key": delete_marker["Key"],
                            "VersionId": delete_marker["VersionId"],
                        }
                    )

            if "Versions" in object_response_itr:
                for version in object_response_itr["Versions"]:
                    version_list.append(
                        {"Key": version["Key"], "VersionId": version["VersionId"]}
                    )

        for i in range(0, len(delete_marker_list), 1000):
            response = s3_client.delete_objects(
                Bucket=s3_bucket_id,
                Delete={"Objects": delete_marker_list[i : i + 1000], "Quiet": True},
            )
            logger.debug(response)

        for i in range(0, len(version_list), 1000):
            response = s3_client.delete_objects(
                Bucket=s3_bucket_id,
                Delete={"Objects": version_list[i : i + 1000], "Quiet": True},
            )
            logger.debug(response)

        logger.info(f"S3 bucket {s3_bucket_id} emptied successfully")

        ## Destroy the terraform.
        e2e_progress.update(
            task_id,
            description="Running: terraform destroy",
            advance=40,
        )
        return_code, stdout, stderr = _terraform_destroy(
            tf, variables=_get_terraform_anyscale_v2_e2e_public_vars_aws()
        )
        if return_code != 0:
            logger.error("Error running: terraform destroy")
            logger.error(stderr)

        logger.info("Destroyed anyscale_v2_e2e_public aws terraform successfully")
        logger.debug(stdout)

        e2e_progress.update(task_id, description="E2E test complete!", completed=100)


def start_gcp_test(
    branch_name: str,
    local_path: str,
    gcp_billing_id: str,
    anyscale_org_id: str,
    root_folder_number: str,
):
    logger.info("Applying anyscale_v2_e2e_public gcp terraform")

    if local_path:
        logger.debug("Using local path")
    else:
        logger.info("Cloning the repo")
        repo_url = "https://github.com/anyscale/terraform-google-anyscale-cloudfoundation-modules/"
        subprocess.check_call(["git", "clone", repo_url])
        # Checkout to a specific branch
        subprocess.check_call(
            ["git", "checkout", branch_name],
            cwd="terraform-aws-anyscale-cloudfoundation-modules",
        )

    tf = Terraform(working_dir=local_path)

    with live:
        task_id = e2e_progress.add_task("", total=100)

        e2e_progress.update(task_id, description="Running: terraform init")
        return_code, stdout, stderr = _terraform_init(tf)
        if return_code != 0:
            raise RuntimeError(f"Error initializing terraform: {stderr}")

        e2e_progress.update(
            task_id,
            description="Running: terraform apply",
            advance=20,
        )
        return_code, stdout, stderr = _terraform_apply(
            tf,
            10,
            _get_terraform_anyscale_v2_e2e_public_vars_gcp(
                billing_account_id=gcp_billing_id,
                anyscale_org_id=anyscale_org_id,
                root_folder_number=root_folder_number,
            ),
        )
        if return_code != 0:
            logger.error("Error running: terraform apply")
            logger.error(stderr)

        logger.info("Applied GCP Terraform: anyscale_v2_e2e_public")

        # pause for GCP to be ready
        _sleep_timer(60)
        e2e_progress.update(
            task_id,
            description="Registering Anyscale GCP cloud...",
            completed=10,
        )

        ## Gather information for registration
        cloud_name = (
            f"test_terraform_anyscale_v2_e2e_public_gcp_{datetime.now().isoformat()}"
        )
        stdout_dict = _parse_registration_command(stdout)
        logger.debug(f"Parsed stdout_dict: {stdout_dict}")
        logger.info("Registering gcp cloud...")
        bucket_name = stdout_dict.get("cloud-storage-bucket-name")

        try:
            cloud_controller = CloudController()
            cloud_controller.register_gcp_cloud(
                region=stdout_dict.get("region"),
                name=cloud_name,
                project_id=stdout_dict.get("project-id"),
                vpc_name=stdout_dict.get("vpc-name"),
                subnet_names=stdout_dict.get("subnet-names").split(","),
                filestore_instance_id=stdout_dict.get("filestore-instance-id"),
                filestore_location=stdout_dict.get("filestore-location"),
                anyscale_service_account_email=stdout_dict.get(
                    "anyscale-service-account-email"
                ),
                instance_service_account_email=stdout_dict.get(
                    "instance-service-account-email"
                ),
                provider_id=stdout_dict.get("provider-name"),
                firewall_policy_names=stdout_dict.get("firewall-policy-names").split(
                    ","
                ),
                cloud_storage_bucket_name=bucket_name,
                # Changed functional_verify=None to
                # allow Anyscale Resources time to be created.
                functional_verify=None,
                private_network=False,
                cluster_management_stack_version="v2",
                memorystore_instance_name=None,
                yes=True,
            )
            logger.info("Cloud registered successfully")
        except Exception as e:
            logger.info(f"Error registering gcp cloud: {e}")

        e2e_progress.update(
            task_id, description="Sleeping: Waiting for Anyscale resources", advance=30
        )
        # pause for 3 min to wait for Anyscale to be ready
        _sleep_timer(60 * 3)
        e2e_progress.update(
            task_id,
            description="Proceeding with Anyscale functional test",
            completed=100,
        )
        e2e_progress.stop_task(task_id)

    ## Verify the cloud.
    logger.info("Starting: Anyscale functional test")
    try:
        cloud_controller.verify_cloud(
            cloud_name=cloud_name,
            cloud_id=None,
            strict=True,
            functional_verify="workspace",
            yes=True,
        )
        logger.info("GCP Cloud verified successfully")
    except Exception as e:
        logger.info(f"Error verifying gcp cloud: {e}")

    with live:
        task_id = e2e_progress.add_task("", total=100)

        ## Delete the cloud.
        e2e_progress.update(task_id, description="Deleting Anyscale AWS cloud...")
        _anyscale_cloud_delete(cloud_controller, cloud_name)

        # ## Emptying bucket
        e2e_progress.update(
            task_id,
            description=f"Emptying bucket {bucket_name}...",
            advance=30,
        )
        try:
            storage_client = storage.Client()
            bucket = storage_client.bucket(bucket_name)

            # get all objects and delete them
            blobs = list(bucket.list_blobs())
            blobs_count = len(blobs)

            step_task_id = step_progress.add_task(
                f"Emptying bucket: {bucket_name}", total=blobs_count
            )

            for blob in blobs:
                blob.delete()
                step_progress.update(step_task_id, advance=1)

            logger.info(f"Bucket {bucket_name} emptied successfully")
            step_progress.stop_task(step_task_id)
            step_progress.update(step_task_id, visible=False)

        except Exception as e:
            logger.info(f"Error emptying bucket {bucket_name}: {e}")

        # Destroy the terraform.
        e2e_progress.update(
            task_id,
            description="Running: terraform destroy",
            advance=40,
        )
        return_code, stdout, stderr = _terraform_destroy(
            tf,
            _get_terraform_anyscale_v2_e2e_public_vars_gcp(
                billing_account_id=gcp_billing_id,
                anyscale_org_id=anyscale_org_id,
                root_folder_number=root_folder_number,
            ),
        )
        if return_code != 0:
            raise RuntimeError(f"Error destroying terraform: {stderr}")

        logger.info("Destroyed anyscale_v2_e2e_public gcp terraform successfully")
        logger.debug(stdout)

        e2e_progress.update(task_id, description="E2E test complete!", completed=100)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--cloud-provider",
        "-c",
        required=True,
        type=str.lower,
        dest="cloudProvider",
        help="The cloud provider to use",
    )
    parser.add_argument(
        "--gcp-billing-id",
        "-g",
        type=str,
        dest="gcpBillingId",
        help="The GCP billing id to use",
    )
    parser.add_argument(
        "--anyscale-org-id",
        "-o",
        type=str,
        dest="anyscaleOrgId",
        help="The Anyscale org id to use",
    )
    parser.add_argument(
        "--root-folder-number",
        "-r",
        type=str,
        dest="rootFolderNumber",
        help="The root folder number to use",
    )
    argGroup = parser.add_mutually_exclusive_group(required=True)
    argGroup.add_argument(
        "--branch-name",
        "-b",
        type=str,
        dest="branchName",
        help="The branch name to use",
    )
    argGroup.add_argument(
        "--local_path",
        "-l",
        type=str,
        dest="localPath",
        help="The local path to use",
    )
    # branch_name = input("What is your branch name? ")
    args, _ = parser.parse_known_args()
    cloud_provider = args.cloudProvider
    branch_name = args.branchName
    local_path = args.localPath

    e2e_progress = Progress(
        TimeElapsedColumn(),
        BarColumn(),
        TextColumn("[bold blue]{task.description}"),
    )
    step_progress = Progress(
        SpinnerColumn(),
        TimeElapsedColumn(),
        BarColumn(),
        TextColumn("[bold blue]{task.description}"),
    )

    progress_group = Group(step_progress, e2e_progress)
    live = Live(progress_group, refresh_per_second=10)
    if cloud_provider == "aws":
        start_aws_test(branch_name, local_path)
    elif cloud_provider == "gcp":
        gcp_billing_id = args.gcpBillingId
        if not gcp_billing_id:
            raise RuntimeError(
                "Please provide the GCP billing id with --gcp-billing-id"
            )
        anyscale_org_id = args.anyscaleOrgId
        if not anyscale_org_id:
            raise RuntimeError(
                "Please provide the Anyscale org id with --anyscale-org-id"
            )
        root_folder_number = args.rootFolderNumber
        if not root_folder_number:
            raise RuntimeError(
                "Please provide the root folder number with --root-folder-number"
            )
        start_gcp_test(
            branch_name, local_path, gcp_billing_id, anyscale_org_id, root_folder_number
        )
    else:
        raise RuntimeError(f"Unsupported cloud provider: {cloud_provider}")
