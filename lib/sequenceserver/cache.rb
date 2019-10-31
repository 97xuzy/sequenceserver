
module SequenceServer
  # Cache the result of a BLAST search
  #
  # Search param and jobid of previously run job are stored in cache.
  # Search param is the key and jobid is the value
  #
  # Each time before a job is added into the job queue, look up in
  # cache to check if this search has been run before.
  # If the job has been run before, redirect to the previous jobid
  class Cache
    class << self
      def enabled?
        return SequenceServer::config[:cache] == "enable"
      end
    end

    def initialize()
      return unless Cache.enabled?
      return if !! @cache
      SequenceServer::logger.info("Cache initialized")
      @cache = {}
    end

    # Query the cache
    def exist?(key)
      jobid = @cache[key]
    end

    # Insert the job into cache
    def insert(job)
      @cache[job.cache_key] = job.id
    end

    # Remove job from cache
    def remove(job)
      @cache.delete(job.cache_key)
    end

    # Flush the redis instance
    def flush
      @cache.clear
    end
  end
end
