require File.expand_path('../spec_helper', __FILE__)

describe Creator do

  include GivenFilesystemSpecHelpers
  
  use_given_filesystem

  let(:settings) do
    s = Settings.new
    s.manifest_path = File.expand_path('spec/data/')
    s.offline = true
    s
  end

  it "checks directory" do
    c = Creator.new settings, "xxx"
    expect{ c.validate_directory }.to raise_error(StandardError)

    c = Creator.new settings, "awesomelib"
    c.validate_directory
  end

  it "creates updated manifest" do
    settings.manifest_path = given_directory do
      given_directory "awesomelib" do
        manifest_filename = given_file "awesomelib.2013-09-08.manifest",
          :from => "awesomelib/awesomelib.2013-09-08.manifest"
      end
    end
    manifest_filename = File.join( settings.manifest_path, "awesomelib",
                                   "awesomelib.2013-10-01.manifest" )
    
    c = Creator.new settings, "awesomelib"

    expect( File.exists?(manifest_filename) ).to be false

    c.update "1.0", "2013-10-01"

    expect( File.exists?(manifest_filename) ).to be true

    mh = ManifestHandler.new settings
    mh.read_remote

    expect(mh.libraries.count).to eq 1
    m = mh.manifest "awesomelib"
    expect(m["name"]).to eq "awesomelib"
    expect(m["version"]).to eq "1.0"
    expect(m["release_date"]).to eq "2013-10-01"
    expect(m["summary"]).to eq "Awesome library"

    expect(mh.manifests.count).to eq 2
    mh.manifests.each do |manifest|
      if manifest["schema_type"] == "generic"
        if manifest["name"] == "commercial"
          expect(manifest.keys.count).to eq 13
        else
          expect(manifest.keys.count).to eq 12
        end
      elsif manifest["schema_type"] == "proprietary-release"
        expect(manifest.keys.count).to eq 15
      else
        expect(manifest.keys.count).to eq 17
      end
    end

    m = JSON File.read(manifest_filename)
    expect(m.keys.count).to eq 13
  end

  it "creates new manifest" do
    settings.manifest_path = given_directory do
      given_directory "newawesomelib"
    end
    manifest_filename = File.join( settings.manifest_path, "newawesomelib",
                                   "newawesomelib.2013-09-01.manifest" )

    c = Creator.new settings, "newawesomelib"
    expect(File.exists?(manifest_filename)).to be false
    
    c.create "edge", "2013-09-01"
    
    expect(File.exists?(manifest_filename)).to be true

    mh = ManifestHandler.new settings
    mh.read_remote

    expect(mh.libraries.count).to eq 1
    m = mh.manifest "newawesomelib"
    expect(m["name"]).to eq "newawesomelib"
    expect(m["version"]).to eq "edge"
    expect(m["release_date"]).to eq "2013-09-01"
    
    v = Verifier.new settings
    result = v.verify m
    if !result.valid?
      result.print_result
    end
    expect(result.valid?).to be true
  end

  it "creates new generic manifest" do
    settings.manifest_path = given_directory do
      given_directory "newawesomelib"
    end
    manifest_filename = File.join( settings.manifest_path, "newawesomelib",
                                   "newawesomelib.manifest" )

    c = Creator.new settings, "newawesomelib"
    expect(File.exists?(manifest_filename)).to be false
    
    c.create_generic
    
    expect(File.exists?(manifest_filename)).to be true

    v = Verifier.new settings
    result = v.verify_file manifest_filename
    if !result.valid?
      result.print_result
    end
    expect(result.valid?).to be true
  end
  
  describe "#create_dir" do

    before(:each) do
      @settings = Settings.new
      @settings.manifest_path = given_directory
    end
    
    it "creates dir" do
      c = Creator.new( @settings, "one" )
      c.create_dir()
      expect( File.exists? File.join( @settings.manifest_path, "one" ) )
        .to be true
      expect( File.directory? File.join( @settings.manifest_path, "one" ) )
        .to be true
    end
    
    it "uses existing dir" do
      c = Creator.new( @settings, "one" )
      c.create_dir()
      c.create_dir()
      expect( File.exists? File.join( @settings.manifest_path, "one" ) )
        .to be true
      expect( File.directory? File.join( @settings.manifest_path, "one" ) )
        .to be true
    end
  end
  
end
