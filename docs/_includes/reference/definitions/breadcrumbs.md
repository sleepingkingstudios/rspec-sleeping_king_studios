{% capture breadcrumbs %}
{% if include.definition.parent_path.size > 0 %}
{% assign parent_definition = site.classes | where: "data_path", include.definition.parent_path | where: "version", page.version | first %}
{%- unless parent_definition %}{% assign parent_definition = site.modules | where: "data_path", include.definition.parent_path | where: "version", page.version | first %}{% endunless %}
{%- include reference/definitions/breadcrumbs.md definition=parent_definition %} | {% include reference/parent_link.md parent_path=include.definition.parent_path -%}
{%- else %}

---

Back to
[Documentation]({{site.baseurl}}/) |
{%- if page.version == "*" %}
[Reference]({{site.baseurl}}/reference)
{%- else %}
[Versions]({{site.baseurl}}/versions) |
[{{ page.version }}]({{site.baseurl}}/versions/{{page.version}}) |
[Reference]({{site.baseurl}}/versions/{{page.version}}/reference)
{% endif %}
{%- endif %}
{% endcapture %}
{{ breadcrumbs | strip }}
