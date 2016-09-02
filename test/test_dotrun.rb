require 'minitest/autorun'
require 'dotrun'
require 'fileutils'

class DotrunTest < Minitest::Test
  
  # Make sure that we get an error printed for stderr if there's no .run file.
  def test_no_directives_file
    err = capture(:err) do
      assert_raises(SystemExit) { Dotrun.new.run("no-directives") }
    end
    assert_includes err, "No .run file"
  end
  
  # Make sure the help screen is printed when we pass the help operator.
  def test_help_screen
    out = capture(:out) do
      assert_raises(SystemExit) { Dotrun.new.run("-?") }
    end
    assert_includes out, "Available directives for"
  end
  
  # Make sure we print out the directives list when we pass the help operator.
  def test_directives_list
    with_fixture do
      out = capture(:out) do
        assert_raises(SystemExit) { Dotrun.new.run("-?") }
      end
      assert_includes out, "echo default"
      assert_includes out, "echo sample"
    end
  end
  
  # Make sure we see the result of the default directive but NOT the sample directive.
  def test_run_default_directive
    with_fixture do
      out = capture_subprocess_io { system "dotrun" }
      assert_includes out.join, "default result"
      assert !out.join.include?("sample result")
    end
  end
  
  # Make sure we see the result of the sample directive but NOT the default.
  def test_run_specific_directive
    with_fixture do
      out = capture_subprocess_io { system "dotrun sample" }
      assert !out.join.include?("default result")
      assert_includes out.join, "sample result"
    end
  end
  
  # Make sure we see the success check mark for both commands.
  def test_multiple_directives
    with_fixture do
      out = capture_subprocess_io { system "dotrun multi" }
      assert_equal 2, out.join.scan(/✔︎/).count
    end
  end
  
  protected

  def capture(*args, &block)
    original_stdout = $stdout
    original_stderr = $stderr
    $stdout = fake_out = StringIO.new
    $stderr = fake_err = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
      $stderr = original_stderr
    end
    if args.include?(:out) && args.include?(:err)
      return fake_out.string, fake_err.string
    elsif args.include?(:out)
      return fake_out.string
    elsif args.include?(:err)
      return fake_err.string
    end
  end

  def with_fixture(*args, &block)
    create_fixture
    begin
      yield
    ensure
      delete_fixture
    end
  end

  def create_fixture
    FileUtils.copy "test/dotrun.sample", ".run"
  end
  
  def delete_fixture
    File.delete(".run")
  end
  
end
