# Contributor's Guide: Get Involved

Thank you for considering becoming a contributor to our project on GitHub. We hope this is a bug-free quickstart guide, but in case you find any issues or want to improve this project in any way we are more than happy to receive your contributions.

This guide is designed to help you get started and provides good insights on how to make an impact on this quickstart. We look forward to your contributions!

# How to contribute

All of our quickstart guides are meant to be simple and concise, yet they must cover basic and advanced deployment scenarios. These guides must assume that for the basic deployment scenario the reader will be provided with all the requirements and necessary commands for the simplest deployment. However, for the advanced scenarios it is expected that the reader will have familiarity with the tooling and requirements, thus requiring only the information necessary to use our templates to produce the desired deployment configuration.

If you need further guidance, you can find our team on our mailing list:

* `quickstart@cyral.com`

We expect that all of the contributors of this project follow our [code of conduct](#code-of-conduct).

## Getting started

If you find any typos, broken links or other types of simple issues, we encourage you to open a Pull Request (PR) directly with the proposed fix, adding at least some context to the description. For more complex issues, however, we kindly ask you to analyze the list of open issues and PRs to avoid you from creating duplicates or working on something that is already assigned to someone else.

Both of our templates for `Pull Requests` or `Issues` will provide the basic structure that you should use to better explain the issue or articulate your ideas in a format that the project's team can follow.

## Coding conventions

1. Use descriptive and concise variable names.
1. Use the `description` properties, if supported, to describe code elements.
1. Include comments to explain complex configurations or unusual decisions.
1. Maintain an up-to-date `README.md`` that provides usage instructions, input variables, and expected outputs.
1. For Terraform code, all declarations (`variable`, `local`, `data source names`, `resource names`, `output`, etc) must be in lowercase with words separated by underscores (e.g., `some_variable_name`).
1. For CloudFormation code, all declarations (`parameters`, `conditions`, `resource`, etc) must use `CamelCase`.
1. For Helm code, follow [The Chart Best Practices Guide](https://helm.sh/docs/chart_best_practices/).

## Code of Conduct

We believe in fostering a welcoming and inclusive environment for all contributors. Please adhere to the following principles when participating in our project:

1. *Respect for All:* We value individuals, thus we respect them regardless of the collective group they belong to. Discrimination, harassment, or any form of disrespectful behaviour will not be tolerated.

1. *Ideas Over Individuals:* We discuss ideas, not people. Personal attacks or ad hominem fallacies are strictly prohibited in all discussions. Constructive critique is encouraged.

1. *Open Dialogue:* We value diverse perspectives and welcome all ideas for consideration. However, the administration team reserves the right to evaluate and make decisions in the best interest of the project's future.

Remember, our goal is to create a collaborative and productive environment where everyone can contribute positively. Let's work together to achieve this.