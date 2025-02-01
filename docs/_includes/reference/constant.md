{% assign const = site.constants | where: "data_path", include.constant.path | where: "version", page.version | first %}
{% capture heading_id %}constant-{{ const.slug }}{% endcapture %}

{% include reference/constants/heading.md constant=const heading_id=heading_id %}

{% include reference/constants/inherited.md constant=const inherited=include.inherited %}

{% include reference/constants/overview.md constant=const heading_id=heading_id %}
