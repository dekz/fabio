class WorkerStack
  def run_env env, sym
    return unless env.is_a? Hash
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
  end
end
