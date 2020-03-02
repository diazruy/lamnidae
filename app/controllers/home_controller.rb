class HomeController < ApplicationController
  def index
    @skills = {
      'Languages' => [
        {from: '2001-02-01', name: "HTML"},
        {from: '2008-07-01', name: "Ruby"},
        {from: '2011-10-01', name: "Ruby on Rails"},
        {from: '2010-09-01', to: '2011-09-01', name: "Flash (Flex 4)"},
        {from: '2001-02-01', to: '2006-03-01', name: "Java/JSP"},
        {from: '2006-03-01', to: '2008-06-01', name: "ColdFusion"},
      ],
      'Javascript' => [
        {from: '2011-09-01', name: "jQuery"},
        {from: '2008-06-01', to: '2011-09-01', name: "Mootools"},
        {from: '2006-03-01', to: '2008-06-08', name: "Prototype"},
        {from: '2011-10-01', name: "Coffeescript"},
        {from: '2014-03-01', to: '2019-02-01', name: "Angular"},
        {from: '2019-02-01', name: "Vue"},
        {from: '2012-08-01', name: "Google Maps API"},
      ],
      'CSS' => [
        {from: '2001-02-01', name: "CSS"},
        {from: '2012-08-01', name: "Bootstrap"},
        {from: '2011-10-01', name: "SASS"},
        {from: '2012-06-01', name: "SMACSS"},
        {from: '2011-10-01', name: "Compass"},
      ],
      'Databases' => [
        {from: '2012-08-01', name: "Solr"},
        {from: '2012-08-01', name: "PostgreSQL"},
        {from: '2015-01-01', name: "PostGIS"},
        {from: '2001-02-01', to: '2012-06-01', name: "MySQL"},
        {from: '2010-01-01', to: '2011-09-01', name: "MongoDB (NoSQL)"},
        {from: '2001-02-01', to: '2004-03-01', name: "Oracle"},
        {from: '2011-10-01', name: "Redis"},
        {from: '2011-10-01', to: '2012-06-01', name: "Sphinx"},
      ],
      'Testing' => [
        {from: '2011-10-01', name: "RSpec"},
        {from: '2008-06-01', to: '2018-03-01', name: "Jasmine"},
        {from: '2019-04-01', name: "Cypress"},
      ],
      'Version Control' => [
        {from: '2008-06-01', name: "Git"},
        {from: '2006-03-01', to: '2007-03-01', name: "Subversion"},
        {from: '2007-03-01', to: '2008-06-01', name: "Perforce"},
      ],
      'PaaS' => [
        {from: '2012-08-01', name: "Heroku"},
      ],
      'OS' => [
        {from: '2001-02-01', to: '2008-06-01', name: "Windows"},
        {from: '2008-06-01', name: "Ubuntu"},
      ],
      'APIs' => [
        {from: '2012-08-01', to: '2019-08-01', name: "Google Maps"},
        {from: '2013-10-01', to: '2019-12-01', name: "Google Fusion Tables"},
        {from: '2012-12-01', name: "Google Analytics"},
        {from: '2014-08-01', to: '2015-04-01', name: "Stripe"},
        {from: '2012-05-01', to: '2015-11-01', name: "Facebook"},
      ]
    }
  end
end
