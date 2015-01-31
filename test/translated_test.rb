require 'minitest'

require 'rubygems'

gem 'activerecord', '>= 1.15.4.7794'
require 'active_record'

require "#{File.dirname(__FILE__)}/../lib/acts_as_translated"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :countries do |t|
      t.column :name_nl, :string
      t.column :name_fr, :string
      t.column :name_en, :string
      t.column :description_nl, :text
      t.column :description_fr, :text
      t.column :description_en, :text
      t.column :created_at, :datetime      
      t.column :updated_at, :datetime
      t.column :position, :integer
    end
  end
end

def fixtures(filename)
  records = YAML.load_file("#{filename}.yml")
  records.each do |key, record|
    Country.create!(record)
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Country < ActiveRecord::Base
  acts_as_translated :name
  acts_as_translated :description
  
  #default_scope :order => 'position'
end

class TranslatedTest < Test::Unit::TestCase
  def setup
    setup_db
    fixtures :countries
  end

  def teardown
    teardown_db
  end

  def test_fixtures
    assert_equal 2, Country.count
    assert_equal 'Belgium', Country.first.name_en
    assert_equal 'Netherlands', Country.last.name_en
  end

  def test_translated_name
    @belgium = Country.first
    @netherlands = Country.last
    
    # test default language
    assert_equal 'Belgium', @belgium.name
    assert_equal 'Netherlands', @netherlands.name
    assert_equal 'Kingdom of Belgium', @belgium.description
    assert_equal 'Kingdom of the Netherlands', @netherlands.description
    
    # change language to dutch
    Country.language = 'nl'
    assert_equal 'België', @belgium.name
    assert_equal 'Nederland', @netherlands.name
    assert_equal 'Koninkrijk België', @belgium.description
    assert_equal 'Koninkrijk der Nederlanden', @netherlands.description
    
    # change language to french
    Country.language = 'fr'
    assert_equal 'Belgique', @belgium.name
    assert_equal 'Pays-Bas', @netherlands.name
    assert_equal 'Royaume de Belgique', @belgium.description
    assert_equal 'Royaume des Pays-Bas', @netherlands.description

    # change language to english
    Country.language = 'en'
    assert_equal 'Belgium', @belgium.name
    assert_equal 'Netherlands', @netherlands.name
    assert_equal 'Kingdom of Belgium', @belgium.description
    assert_equal 'Kingdom of the Netherlands', @netherlands.description
  end
end