{% capture formatted %}
{%- if include.type.items %}
{%- if include.type.ordered %}
{%- include reference/types/ordered_type.md type=include.type -%}
{%- else -%}
{%- include reference/types/array_type.md type=include.type -%}
{%- endif -%}
{% elsif include.type.keys %}
{%- include reference/types/hash_type.md type=include.type -%}
{% else %}
{%- include reference/reference_link.md label=include.type.name path=include.type.path -%}
{% endif -%}
{% endcapture %}
{{- formatted | strip -}}
