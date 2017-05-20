require "spec_helper"

RSpec.describe Scenic::Adapters::Sqlite do
  describe "#create_view" do
    it "successfully creates a view" do
      adapter = described_class.new

      adapter.create_view("greetings", "SELECT 'hi' AS greeting")

      expect(adapter.views.map(&:name)).to include("greetings")
    end
  end

  describe "#update_view" do
    it "updates the view" do
      adapter = described_class.new

      adapter.create_view("greetings", "SELECT 'hi' AS greeting")
      view = adapter.views.find { |v| v.name == "greetings" }
      expect(view.definition).to eq("SELECT 'hi' AS greeting")

      adapter.update_view("greetings", "SELECT 'hello' AS greeting")
      view = adapter.views.find { |v| v.name == "greetings" }
      expect(view.definition).to eq("SELECT 'hello' AS greeting")
    end
  end

  describe "#replace_view" do
    it "raises an exception" do
      adapter = described_class.new
      err = described_class::FeatureNotSupportedError
      adapter.create_view("greetings", "SELECT 'hi' AS greeting")
      expect { adapter.replace_view("greetings", "SELECT text 'hello' AS greeting") }
        .to raise_error err
    end
  end

  describe "#drop_view" do
    it "successfully drops a view" do
      adapter = described_class.new

      adapter.create_view("greetings", "SELECT 'hi' AS greeting")
      adapter.drop_view("greetings")

      expect(adapter.views.map(&:name)).not_to include("greetings")
    end
  end

  describe "#create_materialized_view" do
    it "raises an exception" do
      adapter = described_class.new
      err = described_class::FeatureNotSupportedError

      expect { adapter.create_materialized_view("greetings", "select 1") }
        .to raise_error err
    end
  end

  describe "#update_materialized_view" do
    it "raises an exception" do
      adapter = described_class.new
      err = described_class::FeatureNotSupportedError

      expect { adapter.update_materialized_view("greetings", "select 1") }
        .to raise_error err
    end
  end

  describe "#refresh_materialized_view" do
    it "raises an exception" do
      adapter = described_class.new
      err = described_class::FeatureNotSupportedError

      expect { adapter.refresh_materialized_view("greetings") }
        .to raise_error err
    end
  end

  describe "#drop_materialized_view" do
    it "raises an exception" do
      adapter = described_class.new
      err = described_class::FeatureNotSupportedError

      expect { adapter.drop_materialized_view("greetings") }
        .to raise_error err
    end
  end

  describe "#views" do
    it "returns the views defined on this connection" do
      adapter = described_class.new

      ActiveRecord::Base.connection.execute <<-SQL
            CREATE VIEW parents AS SELECT 'Joe' AS name
      SQL

      ActiveRecord::Base.connection.execute <<-SQL
            CREATE VIEW children AS SELECT 'Owen' AS name
      SQL

      ActiveRecord::Base.connection.execute <<-SQL
            CREATE VIEW people AS
            SELECT name FROM parents UNION SELECT name FROM children
      SQL

      ActiveRecord::Base.connection.execute <<-SQL
            CREATE VIEW people_with_names AS
            SELECT name FROM people
            WHERE name IS NOT NULL
      SQL

      expect(adapter.views.map(&:name)).to eq [
        "parents",
        "children",
        "people",
        "people_with_names",
      ]
    end
  end
end
