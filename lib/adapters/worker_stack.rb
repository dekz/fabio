class WorkerStack
  def run_env env, sym
    if env[:env].member? sym
      z = { :global => env[:env], :out => env[:out] }
      ae = env[:env][sym]
      ae = [ae] if ae.is_a? Hash
      ae = [{ :type => ae}] if ae.is_a? Symbol
      ae.each do |e|
        z[:env] = e
        yield z
      end
    end
  end
end
