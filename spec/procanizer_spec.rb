RSpec.describe Procanizer do
  let(:klass)    { Class.new { extend Procanizer } }
  let(:instance) { klass.new }

  shared_examples "creates proc for method" do
    specify do
      expect(klass.instance_methods).to include(:test, :test_proc)
      expect(instance.test_proc.call).to eq("test")
    end
  end

  context "#add_proc_for" do
    context "with method definition as an argument" do
      before { klass.class_eval { add_proc_for def test; "test"; end } }

      include_examples "creates proc for method"
    end

    context "after method" do
      before do
        klass.class_eval do
          def test
            "test"
          end

          add_proc_for :test
        end
      end

      include_examples "creates proc for method"
    end

    context "aliased as with_proc" do
      before { klass.class_eval { with_proc def test; "test"; end } }

      include_examples "creates proc for method"
    end

    context "with bang" do
      before { klass.class_eval { add_proc_for def test!; "test!"; end } }

      it "creates proc for method" do
        expect(klass.instance_methods).to include(:test!, :test_proc!)
        expect(instance.test_proc!.call).to eq("test!")
      end
    end

    context "with question mark" do
      before { klass.class_eval { add_proc_for def test?; "test?"; end } }

      it "creates proc for method" do
        expect(klass.instance_methods).to include(:test?, :test_proc?)
        expect(instance.test_proc?.call).to eq("test?")
      end
    end

    context "keeps method privacy level" do
      context "private" do
        before do
          klass.class_eval do
            private

            add_proc_for def test
              "test"
            end
          end
        end

        it "creates private proc for method" do
          expect(klass.private_instance_methods).to include(:test, :test_proc)
        end
      end
    
      context "protected" do
        before do
          klass.class_eval do
            protected

            add_proc_for def test
              "test"
            end
          end
        end

        it "creates private proc for method" do
          expect(klass.protected_instance_methods).to include(:test, :test_proc)
        end
      end
    end
  end

  it "has a version number" do
    expect(Procanizer::VERSION).not_to be nil
  end
end