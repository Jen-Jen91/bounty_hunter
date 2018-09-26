require("pg")

class Bounty


  attr_accessor(:name, :bounty_value, :danger_level, :location)
  attr_reader(:id)


  def initialize(options)
    @id            = options["id"].to_i() if options["id"]
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

    values = [@name, @bounty_value, @danger_level, @location]

    db.prepare("save", sql)
    result = db.exec_prepared("save", values)
    @id = result[0]["id"]

    db.close()

  end


# DELETE:

  def self.delete_all()

    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
    })

    sql = "DELETE FROM bounties;"

    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
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


  def self.find(id)

    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
      })

      sql = "
        SELECT * FROM bounties
        WHERE id = $1;
      "

      values = [id]

      db.prepare("find", sql)
      results_array = db.exec_prepared("find", values)
      db.close()

      bounty_hash = results_array[0]
      bounty = Bounty.new(bounty_hash)

      return bounty

  end

  #e.g. Bounty.find(17)


  def self.find_by_name(name)

    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
      })

    sql = "SELECT * from bounties WHERE name = $1;"

    values = [name]

    db.prepare("find_by_name", sql)
    results_array = db.exec_prepared("find_by_name", values)
    db.close()

    bounty_hash = results_array[0]
    bounty = Bounty.new(bounty_hash)

    return bounty

  end

  #e.g. Bounty.find_by_name("Spike Spiegel")




# DELETE ONE:

  def delete_one()

    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
    })

    sql = "DELETE FROM bounties WHERE id = $1;"

    value = [@id]

    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", value)
    db.close()

  end

end
