class Action
  attr_accessor :rental_id, :actor, :gain

  def initialize(rental_id, actor, gain)
    @rental_id = rental_id
    @actor = actor
    @gain = gain
  end

  def self.set(rental_id)
    actions = ObjectSpace.each_object(self).select { |action| action.rental_id == rental_id }
    order = [:driver, :owner, :insurance, :assistance, :drivy]
    actions.sort_by { |action| order.index(action.actor) }
  end

  def self.summary_for(rental_id)
    set(rental_id).map { |action| action.summary }
  end

  def summary
    {
      who: actor.to_s,
      type: type,
      amount: gain.abs.round
    }
  end

  def type
    gain >= 0 ? 'credit' : 'debit'
  end

  def add_gain(new_gain)
    self.gain = new_gain - self.gain
  end
end
