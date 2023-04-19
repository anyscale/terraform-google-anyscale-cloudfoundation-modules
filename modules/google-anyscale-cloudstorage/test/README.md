# google-anyscale-project module unit tests
Requirements:
* Go language (this can be installed locally via `brew install go`)
* terratest which is installed with `go mod tidy` (see below)
* A unit test file whose suffix is: _test.go

More info can be found [here](https://terratest.gruntwork.io/docs/getting-started/quick-start/)

#### Manual execution
Manully running the go tests can save time during initial development. Requires active aws credentials.
```
cd test
go mod init "<module_name>"
go mod tidy
go test -v
```
Where `<module_name>` is the name of the terraform module (can also be `github.com/<your_repo_name>`).

#### Other useful go commands
`go get -t -u` This updates test modules to the latest versions. Must be followed with `go mod tidy`

#### Retrieving Google credentials

### Environment VARS Required

These tests require environment variables to be set for `GOOGLE_BILLING_ACCOUNT_ID` and `GOOGLE_FOLDER_ID`
```bash
export GOOGLE_BILLING_ACCOUNT_ID="01D34E-9FCF25-2A378C"
export GOOGLE_FOLDER_ID="503482899572"
export GOOGLE_PROJECT_ID="terraform-test-project-381523"
```
