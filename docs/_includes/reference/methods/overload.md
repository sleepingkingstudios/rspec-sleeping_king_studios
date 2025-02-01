{% capture overload_id %}{{ include.heading_id }}--overload-{{ include.index }}{% endcapture %}

<h5>
  <code>{{ char }}{{ include.overload.signature }} => {% include reference/methods/return_types.md method=include.overload -%}</code>
</h5>
{: #{{ overload_id }} }

{% include reference/methods/overview.md heading_id=overload_id method=overload overload=true %}

{% include reference/methods/parameters.md heading_id=overload_id method=overload overload=true %}

{% include reference/methods/yields.md heading_id=overload_id method=overload overload=true %}

{% include reference/methods/returns.md heading_id=overload_id method=overload overload=true %}

{% include reference/methods/raises.md heading_id=overload_id method=overload overload=true %}

{% include reference/methods/post_overview.md heading_id=overload_id method=overload overload=true %}
