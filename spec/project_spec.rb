require File.dirname(__FILE__) + '/spec_helper'

describe EDash::Project do
  context "store" do
    let(:store) { mock(:store) }
    before do
      store.stub(:transaction).and_yield
      EDash::Project.stub!(:store).and_return(store)
    end

    context "#all" do
      it "returns all objects in the store" do
        store.stub!(:roots).and_return(['foo'])
        store.should_receive(:[]).with('foo')
        EDash::Project.all
      end
    end
    context "#save" do
      it "saves the project to the store" do
        project = mock(:name => 'foo')
        store.should_receive(:[]=).with('foo', project)
        EDash::Project.save(project)
      end
    end

    context "#find" do
      it "retrieve the project by name" do
        project = mock(:project)
        store.should_receive(:[]).with('foo').and_return(project)
        EDash::Project.find('foo').should == project
      end
    end
  end
  context "no author" do
    subject { EDash::Project.new('project' => 'foo', 'status' => 'pass')}
    its(:author) { should be_nil }
    its(:status) { should == 'pass' }
    its(:name) { should == 'foo' }
    its(:author_email) { should be_nil }
    its(:author_gravatar) { should be_nil }
  end

  context "with an author" do
    let(:author) { 'Chris Parsons <chris@example.com>' }
    subject { EDash::Project.new('project' => 'foo', 'author' => author)}

    its(:author) { should == author }
    its(:author_email) { should match('chris@example.com') }
    its(:author_gravatar) { should match('9655f78d38f380d17931f8dd9a227b9f') }
    its(:to_json) do
      should match(/"name":"foo"/)
      should match(/"author":"Chris/)
      should match(/"author_email":"chris@example.com"/)
    end
  end

  context "adding progress" do
    it "stores the given progress values" do
      project = EDash::Project.new('project' => 'foo')
      progress = mock(:progress)
      project.progress = progress
      project.progress.should == progress
    end
  end
end

