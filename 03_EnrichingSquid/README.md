# Enriching Squid logs
## Objectives
After this lab you will be able to:
 1. Enrich an event with the geo location of ip addresses accessed through the squid proxy. 
 2. Enrich an event with field transformations.
## Adding a geocode enrichment
The geo enrichment applied to an ip address instructs Metron to find the physical location of an ip address and add the location as enrichments to the event.  The ip locations can be used in triaging, hunting, map visualizations, and other analytics. 
1. Open the Metron Configuration UI.
2. Click on the pencil icon to the right of the mysquid sensor to change the sensor configuraiton.  The mysquid configuration opens.

![Edit mysquid sensor](images/edit_mysquid.png)

3. Click on the >> icon to the right of the Schema section.

<img src="images/edit_schema.png" width="50%" height="50%" title="Edit mysquid schema">

4. Click the pencil icon to the right of the ip_dst_addr field.

![Edit IP dst addr enrichments](images/edit_ip_dst_addr_enrich.png)

5. Select geo from the Enrichments drop down.   

<img src="images/ip_dst_addr_geo.png" width="50%" height="50%" title="Edit IP dst addr enrichments">

6. Click Save.
7. Scroll to the bottom of the screen and click Save.
8. Configure your proxy to send web requests to the metron proxy or use curl.  Open google.com 
9. Open the Metron Alerts UI.  The events will now have geo locations on their destination ip addresses.
10. Click between the columns to open the event detail.   The components of the geo enrichments begin with enrichments:geo:ip_dst_addr.   The geocoding includes the following attributes for eac known ip address: city, country, latitude, longitude, postal code, DMA code, location ID, and location point. 

<img src="images/geo_code_enrich_detail.png" width="50%" height="50%" title="Geo code enrichments details">

## Adding field transformations
Field transformations add new fields to the event that are derived from existing fields.   Transformations prepare data for triaging, applying machine learning models or further analytics in the     
1. Open the Metron Configuration UI.
2. Click the pencil icon to the right of the mysquid sensor to change the sensor configuration.  The mysquid configuration opens.

![Edit mysquid sensor](images/edit_mysquid.png)

3. Metron configuration files are in json format.   Simple transformations can be added in the Configuration UI but our example requires more complex transformations.   Transformations are written in a platform specific language called [Stellar](https://docs.hortonworks.com/HDPDocuments/HCP1/HCP-1.5.0/bk_stellar-quick-ref/bk_stellar-quick-ref.pdf).

Click the >> icon to the right of Raw Json in the Advanced section. 

<img src="images/edit_advanced_raw_json.png" width="50%" height="50%" title="Edit advanced raw json">

![config before transformations](images/transformation_config_before.png)

4. On the right side, in the Sensor Parser Config, replace the text:
```
"fieldTransformations": []
```
with the following text:
```
"fieldTransformations": [
		{
			"input": [],
			"output": [
				"full_hostname",
				"domain_without_subdomains"
			],
			"transformation": "STELLAR",
			"config": {
				"full_hostname": "IF (IS_URL(url)) THEN URL_TO_HOST(url) ELSE GET_FIRST(SPLIT(url, ':'))",
				"domain_without_subdomains": "DOMAIN_REMOVE_SUBDOMAINS(full_hostname)"
			}
		}
	]
```

![transformation config after](images/transformations_config_after.png)

5. Click Save under the raw json editors. 
6. Click Save on the lower left of the Sensor configuration file.
7. Generate more squid log entries.
8. Open the Metron Alerts UI.  The latest squid events will have new fields called full_hostname and domain_without_subdomains.  The fields are derived from the url extracted from the original log entry. 

<img src="images/alerts_with transformations.png" width="95%" height="95%" title="Transformations in Alerts UI">

9.  Congratulations!   You have enriched events!  The next step is to triage the events.

## Next Lab
[Triaging squid events.](../04_TriagingSquid/README.md)

## References

[Stellar Quick Reference](https://docs.hortonworks.com/HDPDocuments/HCP1/HCP-1.5.0/bk_stellar-quick-ref/bk_stellar-quick-ref.pdf)

