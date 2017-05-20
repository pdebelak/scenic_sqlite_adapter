module Scenic
  module Adapters
    class Sqlite
      class Views
        def initialize(connection)
          @connection = connection
        end

        def all
          views_from_sqlite.map(&method(:to_scenic_view))
        end

        private

        attr_reader :connection

        def views_from_sqlite
          connection.execute "select name, sql from sqlite_master where type = 'view'"
        end

        def to_scenic_view(result)
          Scenic::View.new(
            name: result["name"],
            definition: extract_definition(result),
            materialized: false,
          )
        end

        def extract_definition(result)
          result["sql"].strip.sub(/\A.*#{result["name"]}\W*AS\s*/, "")
        end
      end
    end
  end
end
