{% assign definition = site.classes | where: "data_path", page.data_path | where: "version", page.version | first %}

# Class: {{ definition.name }}

{% include reference/definitions/details.md definition=definition %}

{% include reference/definitions/table-of-contents.md definition=definition %}

{% include reference/definitions/overview.md definition=definition %}

{% include reference/definitions/subclasses.md definition=definition %}

{% include reference/definitions/definitions.md definition=definition %}

{% include reference/definitions/constants.md definition=definition %}

{% include reference/definitions/class_attributes.md definition=definition %}

{% include reference/definitions/class_methods.md definition=definition %}

{% include reference/definitions/constructor.md definition=definition %}

{% include reference/definitions/instance_attributes.md definition=definition %}

{% include reference/definitions/instance_methods.md definition=definition constructor=definition.constructor %}

{% include reference/definitions/breadcrumbs.md definition=definition %}
