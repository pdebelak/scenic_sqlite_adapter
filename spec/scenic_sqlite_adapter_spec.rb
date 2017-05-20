require "spec_helper"

RSpec.describe ScenicSqliteAdapter do
  it "has a version number" do
    expect(ScenicSqliteAdapter::VERSION).not_to be nil
  end
end
