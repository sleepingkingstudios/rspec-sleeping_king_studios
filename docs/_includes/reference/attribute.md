{% assign method = site.methods | where: "data_path", include.attribute.path | where: "version", page.version | first %}
{% capture prefix %}{{ include.type }}-attribute{% endcapture %}
{% capture heading_id %}{{ prefix }}-{{ method.slug | replace: "=", "--equals" }}{% endcapture %}

{% include reference/attributes/heading.md attribute=include.attribute heading_id=heading_id method=method type=include.type %}

{% include reference/methods/aliases.md method=method %}

{% include reference/methods/inherited.md inherited=include.inherited method=method %}

{% include reference/methods/overview.md method=method heading_id=heading_id prefix=prefix %}

{% include reference/methods/overloads.md heading_id=heading_id method=method %}

{% include reference/methods/parameters.md heading_id=heading_id method=method %}

{% include reference/methods/yields.md heading_id=heading_id method=method %}

{% include reference/methods/returns.md heading_id=heading_id method=method %}

{% include reference/methods/raises.md heading_id=heading_id method=method %}

{% include reference/methods/post_overview.md heading_id=heading_id method=method %}
