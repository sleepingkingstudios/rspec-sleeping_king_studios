## Overview

{% if include.definition.metadata.deprecated %}
> **Deprecated.** {{ include.definition.metadata.deprecated }}
{% endif %}

{% if include.definition.metadata.abstract %}
> **This {{ include.definition.type }} is abstract.** {{ include.definition.metadata.abstract }}
{% endif %}

{% if include.definition.metadata.todos.size > 0 %}
{% for todo in include.definition.metadata.todos %}
> **Todo:** {{ todo }}
{% endfor %}
{% endif %}

{% if include.definition.metadata.notes.size > 0 %}
{% for note in include.definition.metadata.notes %}
> *Note:* {{ note }}
{% endfor %}
{% endif %}

{% if include.definition.short_description %}
{{ include.definition.short_description }}
{% endif %}

{% if include.definition.description %}
{{ include.definition.description }}
{% endif %}

{% if include.definition.metadata.examples.size > 0 %}
### Examples

{% for example in include.definition.metadata.examples %}
{% if example.name.size > 0 %}**{{ example.name }}**{% endif %}
{% highlight ruby %}
{{ example.text }}
{% endhighlight %}
{% endfor %}
{% endif %}

{% if include.definition.metadata.see.size > 0 %}
### See Also

{% for see in include.definition.metadata.see %}
- {% include reference/see_link.md see=see -%}
{% endfor %}
{% endif %}

{% if include.definition.metadata.authors.size > 0 %}
### Author{% if include.definition.metadata.authors.size > 1 %}s{% endif %}

{% for author in include.definition.metadata.authors %}
- {{ author -}}
{% endfor %}
{% endif %}

{% if include.definition.metadata.since.size > 0 %}
### Since

{% for since in include.definition.metadata.since %}
- {{ since -}}
{% endfor %}
{% endif %}

{% if include.definition.metadata.versions.size > 0 %}
### Version{% if include.definition.metadata.versions.size > 1 %}s{% endif %}

{% for version in include.definition.metadata.versions %}
- {{ version -}}
{% endfor %}
{% endif %}

[Back To Top](#)
