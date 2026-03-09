# How to develop and test this feature locally

To test the feature locally there is a testing structure inside the
.devcontainer folder. Use the following command from the root of the projhect to
run the devcontainer:

```bash
devcontainer up \
--config .devcontainer/test-ubuntu/devcontainer.json --remove-existing-container
```

or with custom arguments:

```bash
devcontainer up \
--config .devcontainer/test-ubuntu/devcontainer.json ${DEVCONTAINER_CLI_UP_ARGUMENTS}
```

Then you can connect to the devcontainer and test the feature:

```bash
 devcontainer exec --config .devcontainer/test-ubuntu/devcontainer.json bash
```

To be able to test the feature before a release, you can find a local version in
the `.devcontainer/features` folders.
