{% if include.method.metadata.see.size > 0 %}
{% if include.overload %}
###### See Also
{: #{{ include.heading_id }}--see-also }
{% else %}
#### See Also
{: #{{ include.heading_id }}--see-also }
{% endif %}
{% for see in include.method.metadata.see %}
- {% include reference/see_link.md see=see -%}
{% endfor %}
{% endif %}

{% if include.method.metadata.authors.size > 0 %}
{% if include.overload %}
###### Author{% if include.method.metadata.authors.size > 1 %}s{% endif %}
{: #{{ include.heading_id }}--authors }
{% else %}
#### Author{% if include.method.metadata.authors.size > 1 %}s{% endif %}
{: #{{ include.heading_id }}--authors }
{% endif %}
{% for author in include.method.metadata.authors %}
- {{ author -}}
{% endfor %}
{% endif %}

{% if include.method.metadata.since.size > 0 %}
{% if include.overload %}
###### Since
{: #{{ include.heading_id }}--since }
{% else %}
#### Since
{: #{{ include.heading_id }}--since }
{% endif %}
{% for since in include.method.metadata.since %}
- {{ since -}}
{% endfor %}
{% endif %}

{% if include.method.metadata.versions.size > 0 %}
{% if include.overload %}
###### Version{% if include.method.metadata.versions.size > 1 %}s{% endif %}
{: #{{ include.heading_id }}--versions }
{% else %}
#### Version{% if include.method.metadata.versions.size > 1 %}s{% endif %}
{: #{{ include.heading_id }}--versions }
{% endif %}
{% for version in include.method.metadata.versions %}
- {{ version -}}
{% endfor %}
{% endif %}
