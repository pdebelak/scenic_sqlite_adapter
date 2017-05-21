require_relative "sqlite/views"

module Scenic
  module Adapters
    class Sqlite
      class FeatureNotSupportedError < StandardError
        def initialize
          super "Sqlite3 does not support this feature"
        end
      end

      def initialize(connectable = ActiveRecord::Base)
        @connectable = connectable
      end

      def views
        Views.new(connection).all
      end

      def create_view(name, sql_definition)
        execute "CREATE VIEW #{quote_table_name(name)} AS #{sql_definition};"
      end

      def replace_view(_name, _sql)
        raise FeatureNotSupportedError
      end

      def update_view(name, sql)
        drop_view name
        create_view name, sql
      end

      def drop_view(name)
        execute "DROP VIEW #{quote_table_name(name)};"
      end

      def create_materialized_view(_name, _sql)
        raise FeatureNotSupportedError
      end

      def refresh_materialized_view(_name)
        raise FeatureNotSupportedError
      end

      def update_materialized_view(_name, _sql)
        raise FeatureNotSupportedError
      end

      def drop_materialized_view(_name)
        raise FeatureNotSupportedError
      end

      private

      attr_reader :connectable
      delegate :execute, :quote_table_name, to: :connection

      def connection
        connectable.connection
      end
    end
  end
end
