require("pg")

class Bounty


  attr_accessor(:name, :bounty_value, :danger_level, :location)
  attr_reader(:id)


  def initialize(options)
    @id            = options["id"].to_i()
    @name          = options["name"]
    @bounty_value  = options["bounty_value"].to_i()
    @danger_level  = options["danger_level"]
    @location      = options["location"]
  end


# CREATE:

  def save()

    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
    })

    sql = "
      INSERT INTO bounties (
        name,
        bounty_value,
        danger_level,
        location
      )
      VALUES ($1, $2, $3, $4)
      RETURNING id;
    "

    db.prepare("save", sql)
    result = db.exec_prepared("save", [
      @name,
      @bounty_value,
      @danger_level,
      @location
      ])
    db.close()

    @id = result[0]["id"].to_i()

  end


# DELETE:

  def self.delete_all()

    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
    })

    sql = "DELETE FROM bounties;"

    db.exec(sql)
    db.close()

  end


# READ:

  def self.all()

    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
    })

    sql = "SELECT * FROM bounties;"

    db.prepare("all", sql)
    bounty_hashes = db.exec_prepared("all")
    db.close()

    bounty_objects = bounty_hashes.map do |bounty_hash|
      Bounty.new(bounty_hash)
    end

    return bounty_objects

  end


# UPDATE:

  def update()

    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
    })

    sql = "
      UPDATE bounties
      SET (
        name,
        bounty_value,
        danger_level,
        location
      ) = ($1, $2, $3, $4)
      WHERE id = $5;
      "

    values = [@name, @bounty_value, @danger_level, @location, @id]

    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close()

  end


# FIND:

### -------------- Got very confused here!!

  # def self.find(id)
  #
  #   db = PG.connect({
  #     dbname: "bounty_hunter",
  #     host: "localhost"
  #     })
  #
  #     sql = "
  #       SELECT location FROM bounties
  #       WHERE id = $1;
  #     "
  #
  #     value = [@id]
  #
  #     db.prepare("find", sql)
  #     location_hashes = db.exec_prepared("find", value)
  #     db.close()
  #
  #     location_objects = location_hashes.map do |location_hash|
  #       Bounty.new(location_hash)
  #     end
  #
  #     return location_objects
  #
  # end


# DELETE ONE:

  def delete_one()

    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
    })

    sql = "DELETE FROM bounties WHERE name = $1;"

    value = [@name]

    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", value)
    db.close()

  end


end
