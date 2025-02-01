{% if include.method.aliases.size > 0 %}
*Also known as:*
{% for alias in include.method.aliases %}<code>{{ alias }}</code>{%- unless forloop.last %}, {% endunless -%}{% endfor %}
{% endif %}
