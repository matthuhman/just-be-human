class Point

  def self.get_points(user)
    user_key = "USER_#{user.username}"
    region_key = "REGION_#{user.country}_#{user.region}"
    country_key = "COUNTRY_#{user.country}"

    user_points = get(user_key)
    region_points = get(region_key)
    country_points = get(country_key)

    {
      user_points: user_points,
      region_points: region_points,
      country_points: country_points
    }

  end


  def self.add_event(user, type)
    t = Time.new
    point = {
      pk: "USERPOINT_#{user.username}",
      sk: "#{type.upcase}-#{(t.to_f * 1000).to_i}",
      gsi1: "##{user.country}_#{user.region}"
    }

    params = {
      table_name: table_name,
      item: point
    }

    begin
      client.put_item(params)
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      puts "Unable to add item:"
      puts user.username
      puts "#{error.message}"
    end
  end





  private

    def self.table_name
      ENV["LEADERBOARD_DYNAMO_TABLE"]
    end

    def self.client
      Aws::DynamoDB::Client.new
    end

    def self.get(pk)
      params = {
          table_name: table_name,
          key_condition_expression:
              "pk = :pk and sk = :sk",
          expression_attribute_values: {
              ":pk" => pk,
              ":sk" => "TOTAL"
          }
      }

      result = client.query(params)

      result = result.items.first

      puts result

      result['points'].to_i
    end
end
