/**
 * Copyright (c) 2009 - 2012 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public License,
 * version 2 (GPLv2). There is NO WARRANTY for this software, express or
 * implied, including the implied warranties of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
 * along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 *
 * Red Hat trademarks are not licensed under GPLv2. No permission is
 * granted to use or replicate Red Hat trademarks that are incorporated
 * in this software or its documentation.
 */
package org.candlepin.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

import org.candlepin.jackson.HateoasInclude;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.codehaus.jackson.map.annotate.JsonFilter;
import org.hibernate.annotations.GenericGenerator;

/**
 * UpstreamConsumer
 */
@XmlRootElement
@XmlAccessorType(XmlAccessType.PROPERTY)
@Entity
@Table(name = "cp_import_upstream_consumer")
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonFilter("ApiHateoas")
public class ImportUpstreamConsumer extends AbstractHibernateObject {

    @Id
    @GeneratedValue(generator = "system-uuid")
    @GenericGenerator(name = "system-uuid", strategy = "uuid")
    @Column(length = 32)
    private String id;

    @Column(nullable = false, unique = true)
    private String uuid;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String type;

    @Column(nullable = false, name = "owner_name")
    private String ownerName;

    @Column(length = 255, name = "prefix_url_web")
    private String prefixUrlWeb;

    @Column(length = 255, name = "prefix_url_api")
    private String prefixUrlApi;

    public ImportUpstreamConsumer() {
        // needed for Hibernate
    }

    /**
     * @return the Consumer's uuid
     */
    @HateoasInclude
    public String getUuid() {
        return uuid;
    }

    /**
     * @param uuid the uuid of this consumer.
     */
    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @HateoasInclude
    public String getId() {
        return id;
    }

    /**
     * @param id the db id.
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * @return the name of the consumer.
     */
    @HateoasInclude
    public String getName() {
        return name;
    }

    /**
     * @param name the name of the consumer.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the consumers type.
     */
    public String getType() {
        return type;
    }

    /**
     * @param type the consumer type
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * @return String the owner's name.
     */
    public String getOwnerName() {
        return ownerName;
    }

    /**
     * @param ownerName the owner's name
     */
    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    /**
     * @return Prefix for web url
     */
    public String getWebUrl() {
        return prefixUrlWeb;
    }

    /**
     * @param url
     */
    public void setWebUrl(String url) {
        prefixUrlWeb = url;
    }

    /**
     *
     * @return the api url
     */
    public String getApiUrl() {
        return prefixUrlApi;
    }

    /**
     *
     * @param url
     */
    public void setApiUrl(String url) {
        prefixUrlApi = url;
    }
}
