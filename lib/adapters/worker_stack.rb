require 'stringio'

class WorkerStack
  def run_env env, sym
    return unless env.is_a? Hash
    return unless env.member? :env
    env = env.member?(:env) ? env : { :env => env }
    return unless env.is_a? Hash

    if !env.member?(:out)
      env = { :env => env, :out => StringIO.new }
    end

    if env[:env].member? sym
      z = { :global => env[:env], :out => env[:out] }
      ae = env[:env][sym]
      case ae
      when Hash, TrueClass, FalseClass, String
        ae = [ae]
      when Symbol
        ae = [{ :type => ae}]
      end

      ae.each do |e|
        z[:env] = e
        yield z
      end

    end
    env[:out].rewind
    env
  end
end
