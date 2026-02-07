puts "Seeding database..."

# --- Sample data arrays ---

FIRST_NAMES = %w[Alice Bob Charlie Diana Eve Frank Grace Hank Ivy Jack Kate Leo Mia Noah Olivia
  Paul Quinn Rosa Sam Tina Uma Victor Wendy Xander Yara Zane Aria Blake Carmen Derek
  Elena Finn Gina Hugo Isla Jules Kira Liam Maya Nora Oscar Piper Reed Sara Theo Vera Wade Jax Cleo Dax]

LAST_NAMES = %w[Smith Johnson Williams Brown Jones Garcia Miller Davis Rodriguez Martinez
  Hernandez Lopez Gonzalez Wilson Anderson Thomas Taylor Moore Jackson Martin Lee Perez
  Thompson White Harris Sanchez Clark Ramirez Lewis Robinson Walker Young Allen King Wright
  Scott Torres Nguyen Hill Flores Green Adams Nelson Baker Hall Rivera Campbell Mitchell
  Carter Roberts]

TEAM_NAMES = [
  "Acme Corp", "Globex Industries", "Initech", "Umbrella Labs", "Wayne Enterprises",
  "Stark Solutions", "Pied Piper", "Hooli", "Dunder Mifflin", "Prestige Worldwide"
]

POST_TITLES = [
  "Getting Started with Our Platform", "Q1 Product Roadmap Update", "Best Practices for Team Collaboration",
  "How We Reduced Churn by 30%", "Introducing Our New Dashboard", "Security Update: What You Need to Know",
  "Customer Spotlight: How Acme Uses Our Tool", "5 Tips for Better Onboarding", "API v2 Migration Guide",
  "Year in Review: Our Biggest Milestones", "Building a Culture of Feedback", "Remote Work Best Practices",
  "How to Set Up SSO", "Data-Driven Decision Making", "Scaling Your Team Efficiently",
  "Understanding Our Pricing Model", "New Integration: Slack Notifications", "Performance Improvements in v3.2",
  "How to Export Your Data", "Compliance and GDPR: A Quick Guide", "Feature Request Roundup",
  "Behind the Scenes: Our Engineering Stack", "Tips for Reducing Support Tickets", "Mobile App Beta Launch",
  "How We Handle Incident Response", "Automating Your Workflow", "The Power of Webhooks",
  "Custom Reports: A Deep Dive", "Multi-Tenant Architecture Explained", "What's New in March",
  "Improving Email Deliverability", "How to Use Our CLI Tool", "Billing FAQ",
  "Enterprise Features Overview", "Database Optimization Techniques", "Our Open Source Contributions",
  "User Research Findings", "Accessibility Improvements", "Load Testing Results",
  "Migrating from v1 to v2", "How We Do Code Reviews", "Setting Up CI/CD Pipelines",
  "Monitoring and Alerting Guide", "Kubernetes Deployment Guide", "GraphQL vs REST: Our Take",
  "New Team Roles and Permissions", "Changelog: February Updates", "How to Use Audit Logs",
  "Building Custom Dashboards", "API Rate Limiting Explained"
]

PARAGRAPHS = [
  "This is an important update that affects all users. Please read carefully and reach out if you have questions.",
  "We've been working hard on improving the platform experience. Here's what changed and why it matters.",
  "After extensive user research and feedback sessions, we decided to revamp this feature from the ground up.",
  "Performance has always been a priority for us. In this release, we've optimized several key areas.",
  "Security is paramount. We regularly audit our systems and this post covers our latest findings.",
  "Our team has grown significantly this quarter. Here's how we're scaling our processes to match.",
  "Customer feedback drove this change. We listened and here's what we built as a result.",
  "This guide walks you through the setup process step by step. Screenshots included below.",
  "We analyzed usage patterns across thousands of accounts to identify the most requested features.",
  "The engineering team spent three sprints on this refactor. Here's what we learned along the way.",
]

COMMENT_BODIES = [
  "Great post! This is exactly what we needed.", "Thanks for sharing this update.",
  "Could you elaborate on the pricing changes?", "We've been waiting for this feature!",
  "How does this compare to the previous version?", "Excellent write-up, very informative.",
  "Will this be available on the free plan?", "Our team is excited about this release.",
  "Any timeline for the mobile version?", "This solved a major pain point for us.",
  "Can you share more details about the API changes?", "Love the new dashboard design!",
  "How do we migrate our existing data?", "The performance improvements are noticeable.",
  "Is there a webinar planned for this topic?", "Bookmarked for our next team meeting.",
  "This is a game changer for our workflow.", "Would love to see a video tutorial on this.",
  "Does this work with the Slack integration?", "Impressive work by the engineering team!",
]

TAG_NAMES = %w[engineering product design marketing support billing security api
  performance infrastructure devops frontend backend mobile analytics]

PLANS = [:free, :starter, :pro, :enterprise]
POST_STATUSES = [:draft, :published, :published, :published, :archived] # weighted toward published
INVOICE_STATUSES = [:pending, :paid, :paid, :paid, :overdue] # weighted toward paid

# --- Create Users ---

users = 50.times.map do |i|
  User.create!(
    name: "#{FIRST_NAMES[i]} #{LAST_NAMES[i]}",
    email: "#{FIRST_NAMES[i].downcase}.#{LAST_NAMES[i].downcase}@example.com",
    role: i < 5 ? :admin : :member
  )
end
puts "  Created #{users.size} users"

# --- Create Teams ---

teams = TEAM_NAMES.map.with_index do |name, i|
  Team.create!(name: name, plan: PLANS[i % PLANS.size])
end
puts "  Created #{teams.size} teams"

# --- Create Memberships ---

membership_count = 0
teams.each_with_index do |team, ti|
  # Each team gets 5-12 members
  member_count = 5 + (ti * 3) % 8
  team_users = users.rotate(ti * 4).first(member_count)

  team_users.each_with_index do |user, ui|
    role = if ui == 0
      :owner
    elsif ui < 2
      :admin
    else
      :member
    end
    Membership.create!(user: user, team: team, role: role)
    membership_count += 1
  end
end
puts "  Created #{membership_count} memberships"

# --- Create Tags ---

tags = TAG_NAMES.map { |name| Tag.create!(name: name) }
puts "  Created #{tags.size} tags"

# --- Create Posts ---

posts = 200.times.map do |i|
  user = users[i % users.size]
  team = teams[i % teams.size]
  status = POST_STATUSES[i % POST_STATUSES.size]
  title = POST_TITLES[i % POST_TITLES.size]
  title = "#{title} (##{i / POST_TITLES.size + 1})" if i >= POST_TITLES.size
  body = (1 + i % 3).times.map { PARAGRAPHS[rand(PARAGRAPHS.size)] }.join("\n\n")

  Post.create!(
    title: title,
    body: body,
    status: status,
    user: user,
    team: team,
    created_at: rand(180).days.ago,
    updated_at: rand(30).days.ago
  )
end
puts "  Created #{posts.size} posts"

# --- Create PostTags ---

post_tag_count = 0
posts.each_with_index do |post, i|
  tag_count = 1 + i % 4
  selected_tags = tags.rotate(i).first(tag_count)
  selected_tags.each do |tag|
    PostTag.create!(post: post, tag: tag)
    post_tag_count += 1
  end
end
puts "  Created #{post_tag_count} post_tags"

# --- Create Comments ---

comments = 500.times.map do |i|
  post = posts[i % posts.size]
  user = users[(i * 7) % users.size] # spread commenters around
  body = COMMENT_BODIES[i % COMMENT_BODIES.size]

  Comment.create!(
    body: body,
    post: post,
    user: user,
    created_at: post.created_at + rand(30).days
  )
end
puts "  Created #{comments.size} comments"

# --- Create Invoices ---

invoices = 100.times.map do |i|
  team = teams[i % teams.size]
  status = INVOICE_STATUSES[i % INVOICE_STATUSES.size]
  due_date = Date.today - rand(180) + rand(60)
  amount = [29.99, 49.99, 99.99, 199.99, 499.99, 999.00][i % 6]
  paid_at = status == :paid ? (due_date - rand(10).days).to_datetime : nil

  Invoice.create!(
    team: team,
    amount: amount,
    status: status,
    due_date: due_date,
    paid_at: paid_at
  )
end
puts "  Created #{invoices.size} invoices"

puts "Seeding complete!"
