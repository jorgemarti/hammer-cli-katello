module HammerCLIKatello
  module PuppetEnvironmentNameResolvable
    class PuppetEnvParamSource < HammerCLI::Options::Sources::Base
      def initialize(command)
        @command = command
      end

      def get_options(_defined_options, result)
        if result['option_environment_id'].nil? && result['option_environment_name']
          result['option_environment_id'] = @command.resolver.puppet_environment_id(
            @command.resolver.scoped_options('environment', result, :single))
        end
        result
      end
    end

    def option_sources
      sources = super
      sources.find_by_name('IdResolution').insert_relative(
        :after,
        'IdParams',
        PuppetEnvParamSource.new(self)
      )
      sources
    end
  end
end
