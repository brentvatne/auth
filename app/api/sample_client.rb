module Api
  class SampleClient
    class << self
      def baseUrl
        @baseUrl ||=
          'http://nsscreencast-auth-server.herokuapp.com'
      end

      # Valid response:
      #
      # { "auth_token_expires_at" => "2012-11-18T02:26:38Z",
      #   "username"              => "admin4",
      #   "auth_token"            => "1b9fabe2b36e81a6c7a6991a0353fe5355ec13f7",
      #   "email"                 => "admin4@example.com" }
      #
      def self.authenticate(login, password, &block)
        payload = {payload: {username: login, password: password}}

        BW::HTTP.post(authenticationPath, payload) do |response|
          if response.ok?
            parsedResponse = BW::JSON.parse(response.body.to_str)
            saveNewToken(parsedResponse[:auth_token])
            $stdout.puts parsedResponse
            block.call(true, parsedResponse)
          elsif response.status_code.to_s =~ /40\d/
            App.alert("Invalid credentials")
            block.call(false, nil)
          else
            App.alert("Server error")
            block.call(false, nil)
          end
        end
      end

      def authenticationPath
        "#{baseUrl}/auth/login.json"
      end

      def indexPath
        # add auth_token header
      end

      def token
        App::Persistence['SampleToken']
      end

      def saveNewToken(token)
        App::Persistence['SampleToken'] = token
      end
    end
  end
end

