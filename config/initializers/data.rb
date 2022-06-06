DefaultData = lambda do
  Struct
    .new(:users, :courses, :enrollments)
    .new(
      { id: 0, data: [] },
      { id: 5, data: [
          {
            id: 1,
            name: "Nestjs 101"
          },
          {
            id: 2,
            name: "成為 Nestjs 大師的路上"
          },
          {
            id: 3,
            name: "從零開始的 nestjs 之旅"
          },
          {
            id: 4,
            name: "You Don't Know Js"
          },
          {
            id: 5,
            name: "I Don't Know Js yet"
          }
        ]},
      { id: 0, data: [] },
    )
end

Data = DefaultData.clone
