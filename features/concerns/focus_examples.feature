# features/concerns/focus_examples.feature

Feature: `FocusExamples` concern
  Use the `FocusExamples` concern to add a shorthand for focusing or skipping
  shared example groups, in the same fashion as using the `fit` or `fdescribe`
  methods in lieu of `it` and `describe`.

  ```ruby
  RSpec.describe "a Hash" do
    include RSpec::SleepingKingStudios::Concerns::WrapExamples

    shared_examples 'should be accessible with :[]' do
      it { expect(instance[:greetings]).to be == 'starfighter' }
    end # shared_examples

    shared_examples 'should be accessible as a method' do
      it { expect(instance.greetings).to be == 'starfighter' }
    end # shared_examples

    let(:instance) { { :greetings => 'starfighter' } }

    it { expect(instance.keys).to contain_exactly :greetings }

    finclude_examples 'should be accessible with :[]' # Focused examples, perhaps to debug a failing spec.

    xinclude_examples 'should be accessible as a method' # Skipped examples, perhaps due to unimplemented functionality.
  end # describe
  ```

  Scenario: focusing an example group
    Given a file named "wrapping_examples.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/concerns/focus_examples'

        RSpec.configure do |config|
          # Limit a spec run to individual examples or groups you care about by tagging
          # them with `:focus` metadata.
          config.filter_run :focus
          config.run_all_when_everything_filtered = true
        end # configure

        Song = Struct.new(:title, :artist, :genre)

        RSpec.describe Song do
          extend RSpec::SleepingKingStudios::Concerns::FocusExamples

          shared_examples 'should have a title' do
            it { expect(song.title).not_to be_nil }
          end # shared_examples

          shared_examples 'should be metal' do
            it { expect(song.genre).to be == 'Metal' }
          end # shared_examples

          describe 'with a country song' do
            let(:song) { Song.new 'Thinking of You', 'Christian Kane', 'Country' }

            it { expect(song.artist).to be == 'Christian Kane' }

            include_examples 'should have a title'

            finclude_examples 'should be metal'
          end # describe

          describe 'with a metal song' do
            let(:song) { Song.new 'Mz. Hyde', 'Halestorm', 'Metal' }

            it { expect(song.artist).to be == 'Halestorm' }

            include_examples 'should have a title'

            finclude_examples 'should be metal'
          end # describe
        end # describe
      """
    When I run `rspec wrapping_examples.rb`
    Then the output should contain "2 examples, 1 failure"
    Then the output should contain consecutive lines:
      | 1) Song with a country song (focused) <%= Spec::RSPEC_VERSION >= '3.9' ? 'is expected to' : 'should' %> be == Metal |
      |    Failure/Error: it { expect(song.genre).to be == 'Metal' } |

  Scenario: skipping an example group
    Given a file named "wrapping_examples.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/concerns/focus_examples'

        RSpec.configure do |config|
          # Limit a spec run to individual examples or groups you care about by tagging
          # them with `:focus` metadata.
          config.filter_run :focus
          config.run_all_when_everything_filtered = true
        end # configure

        Song = Struct.new(:title, :artist, :genre)

        RSpec.describe Song do
          extend RSpec::SleepingKingStudios::Concerns::FocusExamples

          shared_examples 'should have a title' do
            it { expect(song.title).not_to be_nil }
          end # shared_examples

          shared_examples 'should be disco' do
            it { expect(song.genre).to be == 'Disco' }
          end # shared_examples

          describe 'with a country song' do
            let(:song) { Song.new 'Thinking of You', 'Christian Kane', 'Country' }

            it { expect(song.artist).to be == 'Christian Kane' }

            include_examples 'should have a title'

            xinclude_examples 'should be disco'
          end # describe

          describe 'with a metal song' do
            let(:song) { Song.new 'Mz. Hyde', 'Halestorm', 'Metal' }

            it { expect(song.artist).to be == 'Halestorm' }

            include_examples 'should have a title'

            xinclude_examples 'should be disco'
          end # describe
        end # describe
      """
    When I run `rspec wrapping_examples.rb`
    Then the output should contain "6 examples, 0 failures, 2 pending"
    Then the output should contain consecutive lines:
      | 1) Song with a country song (skipped) |
      |    # Temporarily skipped with xdescribe |
    Then the output should contain consecutive lines:
      | 2) Song with a metal song (skipped) |
      |    # Temporarily skipped with xdescribe |
