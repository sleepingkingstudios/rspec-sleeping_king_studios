{% capture parent_link %}
{% assign parent_definition = site.classes | where: "data_path", include.parent_path | where: "version", page.version | first %}
{% unless parent_definition %}{% assign parent_definition = site.modules | where: "data_path", include.parent_path | where: "version", page.version | first %}{% endunless %}
{% if parent_definition %}{% include reference/reference_link.md label=parent_definition.name path=parent_definition.data_path -%}{% else %}Object{% endif %}
{% endcapture %}
{{ parent_link | strip }}
