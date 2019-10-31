
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
    @@cache = nil
    class << self
      def enabled?
        #return SequenceServer::config[:cache] == "enable"
        return true
      end
    end

    def initialize()
      return unless Cache.enabled?
      SequenceServer::logger.info("Cache initialized")
      @@cache = {}
    end

    # Query the cache
    def exist?(key)
      return nil if @@cache.nil?
      jobid = @@cache[key]
    end

    # Insert the job into cache
    def insert(job)
      return if @@cache.nil?
      @@cache[job.cache_key] = job.id
    end

    # Remove job from cache
    def remove(job)
      return if @@cache.nil?
      @@cache.delete(job.cache_key)
    end

    # Flush the redis instance
    def flush
      return if @@cache.nil?
      @@cache.clear
    end
  end
end
