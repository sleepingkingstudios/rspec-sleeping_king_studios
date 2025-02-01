{% if include.constant.metadata.todos.size > 0 %}
{% for todo in include.constant.metadata.todos %}
> **Todo:** {{ todo }}
{% endfor %}
{% endif %}

{% if include.constant.metadata.notes.size > 0 %}
{% for note in include.constant.metadata.notes %}
> *Note:* {{ note }}
{% endfor %}
{% endif %}

{% if include.constant.short_description %}
{{ include.constant.short_description }}
{% endif %}

{% if include.constant.description %}
{{ include.constant.description }}
{% endif %}

{% if include.constant.metadata.examples.size > 0 %}
#### Examples
{: #{{ include.heading_id }}--examples }
{% for example in include.constant.metadata.examples %}
{% if example.name.size > 0 %}**{{ example.name }}**{% endif %}
{% highlight ruby %}{{ example.text }}{% endhighlight %}
{% endfor %}
{% endif %}

{% if include.constant.metadata.see.size > 0 %}
#### See Also
{: #{{ include.heading_id }}--see-also }
{% for see in include.constant.metadata.see %}
- {% include reference/see_link.md see=see -%}
{% endfor %}
{% endif %}

{% if include.constant.metadata.authors.size > 0 %}
#### Author{% if include.constant.metadata.authors.size > 1 %}s{% endif %}
{: #{{ include.heading_id }}--authors }
{% for author in include.constant.metadata.authors %}
- {{ author -}}
{% endfor %}
{% endif %}

{% if include.constant.metadata.since.size > 0 %}
#### Since
{: #{{ include.heading_id }}--since }
{% for since in include.constant.metadata.since %}
- {{ since -}}
{% endfor %}
{% endif %}

{% if include.constant.metadata.versions.size > 0 %}
#### Version{% if include.constant.metadata.versions.size > 1 %}s{% endif %}
{: #{{ include.heading_id }}--versions }
{% for version in include.constant.metadata.versions %}
- {{ version -}}
{% endfor %}
{% endif %}
