RSpec.describe Context::Context do
  let(:default_value) {  :foo }
  subject { described_class.new(default_value: default_value) }

  it "delegates everithing" do
    foo = double("foo")
    expect(foo).to receive(:haha).and_return(nil)
    subject.with(foo) do
      subject.haha
    end
  end

  describe "#with" do
    context "nothing has setted" do
      it "returns default value" do
        expect(subject.get).to eql(default_value)
      end
    end

    context "with something set" do
      it "returns something" do
        subject.with(:bar) do
          expect(subject.get).to eql(:bar)
        end
      end

      it "resets to default value after block" do
        subject.with(:bar) do
        end
        expect(subject.get).to eql(default_value)
      end
    end

    context "threadsafe" do
      it "is threadsafe" do
        threads = []
  
        subject.with(:baz) do
          Thread.new {
            expect(subject.get).to eql(:baz)
            Thread.new {
              expect(subject.get).to eql(:baz)

              subject.with(:foo) do
                expect(subject.get).to eql(:foo)
              end

              expect(subject.get).to eql(:baz)
            }.join
            expect(subject.get).to eql(:baz)
            
          }.join

          expect(subject.get).to eql(:baz)

          Thread.new {
            expect(subject.get).to eql(:baz)
          }.join

          threads << Thread.new {
            10.times do
              expect(subject.get).to eql(:baz)
              sleep 0.03
            end
          }
  
          threads << Thread.new {
            subject.with(:foo) do
              10.times do
                expect(subject.get).to eql(:foo)
                sleep 0.03
              end
            end
          }
  
          threads << Thread.new {
            subject.with(:bar) do
              10.times do
                sleep 0.03
                expect(subject.get).to eql(:bar)
              end
            end
          }
  
          expect(subject.get).to eql(:baz)
  
          threads.map &:join
  
          expect(subject.get).to eql(:baz)
        end

        expect(subject.get).to eql(default_value)
      end
    end
  end
  
end
