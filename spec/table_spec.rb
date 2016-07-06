require 'spec_helper'

describe "The format:table command" do
  let(:command_name) { "table" }

    context "on the final invocation" do
      before(:each) { ENV["COG_INVOCATION_STEP"] = "last" }

      let(:cog_env) do
        [
          {"hello" => "world", "goodbye" => "cruel world"},
          {"hello" => "mundo", "outer" => {"middle" => {"inner" => "sanctum"}}},
          {"hello" => "monde", "outer" => {"inside" => "yay"}}
        ]
      end

      it "makes a simple table" do
        run_command(args: ["hello"])
        expect(command).to respond_with_text(<<eom)
+-------+
| hello |
+-------+
| world |
| mundo |
| monde |
+-------+
eom
      end

      it "handles inputs that don't have a given field" do
        run_command(args: ["hello", "goodbye"])
        expect(command).to respond_with_text(<<eom)
+-------+-------------+
| hello |   goodbye   |
+-------+-------------+
| world | cruel world |
| mundo |             |
| monde |             |
+-------+-------------+
eom
      end

      it "can rename top-level fields" do
        run_command(args: ["planet=hello"])
        expect(command).to respond_with_text(<<eom)
+--------+
| planet |
+--------+
| world  |
| mundo  |
| monde  |
+--------+
eom
      end

      it "can extract nested data" do
        run_command(args: ["outer.middle.inner"])
        expect(command).to respond_with_text(<<eom)
+---------+
|  inner  |
+---------+
|         |
| sanctum |
|         |
+---------+
eom
      end

      it "can rename nested data" do
        run_command(args: ["latin=outer.middle.inner"])
        expect(command).to respond_with_text(<<eom)
+---------+
|  latin  |
+---------+
|         |
| sanctum |
|         |
+---------+
eom
      end

      it "conflicting renames show full path when conflict comes later" do
        run_command(args: ["hello", "hello=outer.middle.inner"])
        expect(command).to respond_with_text(<<eom)
+-------+--------------------+
| hello | outer.middle.inner |
+-------+--------------------+
| world |                    |
| mundo | sanctum            |
| monde |                    |
+-------+--------------------+
eom
      end

      it "conflicting renames show full path when conflict comes first" do
        run_command(args: ["hello=outer.middle.inner", "hello"])
        expect(command).to respond_with_text(<<eom)
+--------------------+-------+
| outer.middle.inner | hello |
+--------------------+-------+
|                    | world |
| sanctum            | mundo |
|                    | monde |
+--------------------+-------+
eom
      end

      it "full paths are only shown for conflictingly-named columns" do
        run_command(args: ["hello=outer.middle.inner", "outer.inside", "hello"])
        expect(command).to respond_with_text(<<eom)
+--------------------+--------+-------+
| outer.middle.inner | inside | hello |
+--------------------+--------+-------+
|                    |        | world |
| sanctum            |        | mundo |
|                    | yay    | monde |
+--------------------+--------+-------+
eom
      end
    end

end
