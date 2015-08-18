require 'minitest/autorun'
require 'minitest/pride'
require 'active_record'
require 'acts_as_translated'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

def capture_stdout(&block)
  real_stdout = $stdout

  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = real_stdout
end

def setup_db
  capture_stdout do
    ActiveRecord::Base.logger
    ActiveRecord::Schema.define(:version => 1) do
      create_table :countries do |t|
        t.column :iso, :string, index: true, unique: true, null: false
        t.column :name_nl, :string
        t.column :name_fr, :string
        t.column :name_en, :string
        t.column :description_nl, :text
        t.column :description_fr, :text
        t.column :description_en, :text
        t.column :slug_nl, :string
        t.column :slug_fr, :string
        t.column :slug_en, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :position, :integer
      end
    end
  end
end

def fixtures(filename)
  records = YAML.load_file(File.join(__dir__, "#{filename}.yml"))
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
	include ActsAsTranslated

  acts_as_translated :name, :description, default: :nl
  acts_as_translated :slug
end



class ActsAsTranslatedTest < Minitest::Test

  def setup
    setup_db
    fixtures :countries
  end

  def teardown
    teardown_db
  end

	def test_version
		refute_nil ActsAsTranslated::VERSION
	end

  def test_fixtures
    assert_equal 3, Country.count
    assert_equal 'Belgium', Country.find_by_iso(:be).name_en
    assert_equal 'Netherlands', Country.find_by_iso(:nl).name_en
    assert_equal 'France', Country.find_by_iso(:fr).name_fr
  end

  def test_acts_as_translated_attribute_presence
    refute_respond_to Country.new, :acts_as_translated_attribute
    assert_respond_to Country, :acts_as_translated_attribute

  end

  def test_acts_as_translated_attribute_matches
    @country = Country.find_by_iso(:be)

    assert_equal 'België', Country.acts_as_translated_attribute(@country, 'name', 'nl')
    assert_equal 'Belgique', Country.acts_as_translated_attribute(@country, 'name', 'fr')
    assert_equal 'Royaume de Belgique', Country.acts_as_translated_attribute(@country, 'description', 'fr')

    @country = Country.find_by_iso(:nl)

    assert_equal 'Nederland', Country.acts_as_translated_attribute(@country, :name, :nl)
    assert_equal 'Pays-Bas', Country.acts_as_translated_attribute(@country, :name, :fr)
    assert_equal 'Kingdom of the Netherlands', Country.acts_as_translated_attribute(@country, 'description', :en)
  end

  def test_acts_as_translated_attribute_defaults
    @country = Country.find_by_iso(:be)

    assert_equal 'België', Country.acts_as_translated_attribute(@country, 'name', 'es', default: 'nl')
    assert_equal 'Belgium', Country.acts_as_translated_attribute(@country, 'name', 'de')
    assert_equal 'Royaume de Belgique', Country.acts_as_translated_attribute(@country, 'description', 'ch', default: 'fr')

    @country = Country.find_by_iso(:nl)

    assert_equal 'Nederland', Country.acts_as_translated_attribute(@country, :name, :es, default: :nl)
    assert_equal 'Netherlands', Country.acts_as_translated_attribute(@country, :name, :de)
    assert_equal 'Koninkrijk der Nederlanden', Country.acts_as_translated_attribute(@country, :description, :ch, default: :nl)
  end

  def test_acts_as_translated_attribute_no_default
    @country = Country.find_by_iso(:be)

    assert_raises NoMethodError do
      Country.acts_as_translated_attribute(@country, 'name', 'es', default: 'es')
    end

    assert_raises NoMethodError do
      Country.acts_as_translated_attribute(@country, :name, :es, default: :es)
    end

    assert_raises NoMethodError do
      Country.acts_as_translated_attribute(@country, 'position', 'es')
    end

    assert_raises NoMethodError do
      Country.acts_as_translated_attribute(@country, :position, :es)
    end
  end

  def test_method_generation
    @country = Country.find_by_iso(:be)

    refute_respond_to Country, :description
    assert_respond_to @country, :description
    assert_respond_to @country, :name
    assert_respond_to @country, :slug
  end

  def test_acts_as_translated_attributes
    @belgium = Country.find_by_iso(:be)
    @netherlands = Country.find_by_iso(:nl)

    I18n.enforce_available_locales = false

    I18n.locale = :nl

    assert_equal 'België', @belgium.name
    assert_equal 'Koninkrijk België', @belgium.description
    assert_equal 'belgie', @belgium.slug

    assert_equal 'Nederland', @netherlands.name
    assert_equal 'Koninkrijk der Nederlanden', @netherlands.description
    assert_equal 'nederland', @netherlands.slug


    I18n.locale = :fr

    assert_equal 'Belgique', @belgium.name
    assert_equal 'Royaume de Belgique', @belgium.description
    assert_equal 'belgique', @belgium.slug

    assert_equal 'Pays-Bas', @netherlands.name
    assert_equal 'Royaume des Pays-Bas', @netherlands.description
    assert_equal 'pays-bas', @netherlands.slug

    I18n.locale = :en

    assert_equal 'Belgium', @belgium.name
    assert_equal 'Kingdom of Belgium', @belgium.description
    assert_equal 'belgium', @belgium.slug

    assert_equal 'Netherlands', @netherlands.name
    assert_equal 'Kingdom of the Netherlands', @netherlands.description
    assert_equal 'netherlands', @netherlands.slug
  end

  def test_acts_as_translated_attribute_defaults
    @belgium = Country.find_by_iso(:be)
    @netherlands = Country.find_by_iso(:nl)

    I18n.enforce_available_locales = false

    I18n.locale = :es

    assert_equal 'België', @belgium.name
    assert_equal 'Koninkrijk België', @belgium.description
    assert_equal 'belgium', @belgium.slug

    assert_equal 'Nederland', @netherlands.name
    assert_equal 'Koninkrijk der Nederlanden', @netherlands.description
    assert_equal 'netherlands', @netherlands.slug
  end

end