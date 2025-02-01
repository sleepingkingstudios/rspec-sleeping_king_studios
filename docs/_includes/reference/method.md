{% assign method = site.methods | where: "data_path", include.path | where: "version", page.version | first %}
{% if method %}
{% capture prefix %}{{ include.type }}-method{% endcapture %}
{% capture heading_id %}{{ prefix }}-{{ method.slug | replace: "=", "--equals" | replace: "?", "--predicate" }}{% endcapture %}

{% include reference/methods/heading.md heading_id=heading_id method=method type=include.type %}

{% include reference/methods/aliases.md method=method %}

{% include reference/methods/inherited.md inherited=include.inherited method=method %}

{% include reference/methods/overview.md heading_id=heading_id method=method %}

{% include reference/methods/overloads.md heading_id=heading_id method=method %}

{% include reference/methods/parameters.md heading_id=heading_id method=method %}

{% include reference/methods/yields.md heading_id=heading_id method=method %}

{% include reference/methods/returns.md heading_id=heading_id method=method %}

{% include reference/methods/raises.md heading_id=heading_id method=method %}

{% include reference/methods/post_overview.md heading_id=heading_id method=method %}
{% else %}
### Missing Method: {{ include.path }} @ {{ page.version }}
{% endif %}
