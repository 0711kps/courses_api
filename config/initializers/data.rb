Data = Struct.new(:users, :courses, :enrollments).new(*3.times.map { { id: 0, data: [] } })
