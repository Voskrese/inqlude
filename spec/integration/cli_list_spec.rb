require_relative "spec_helper"

include CliTester

describe "Command line interface" do
  include GivenFilesystemSpecHelpers

  use_given_filesystem

  describe "list" do
    it "lists libraries" do

      dir = given_directory do
        given_directory_from_data("awesomelib")
        given_directory_from_data("newlib")
      end

      result = run_command(args: ["list", "--remote", "--offline",
        "--manifest_dir=#{dir}"])
      expect(result).to exit_with_success("awesomelib (0.2.0)\n")
    end
  end
end