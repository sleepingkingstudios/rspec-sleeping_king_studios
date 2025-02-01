{% if include.method.overloads.size > 0 %}
#### Overloads
{: #{{ include.heading_id }}--overloads }

{% for overload in include.method.overloads %}
<div class="overload" style="margin-left: 2rem;">
  {% assign index = forloop.index %}
  {% capture rendered %}{% include reference/methods/overload.md heading_id=heading_id index=index overload=overload %}{% endcapture %}
{{ rendered | strip | markdownify }}
</div>
{% endfor %}
{% endif %}
