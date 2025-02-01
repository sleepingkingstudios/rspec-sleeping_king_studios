{%- if include.see.type == 'link' -%}
[{{ include.see.label }}]({{include.see.path}}) {{ include.see.text }}
{%- elsif include.see.type == 'reference' -%}
{% include reference/reference_link.md label=include.see.label path=include.see.path %} {{ include.see.text }}
{%- else -%}
{{ include.see.text }}
{%- endif -%}
