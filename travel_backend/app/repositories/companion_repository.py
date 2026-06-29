class CompanionRepository:

    async def get_dashboard(self):
        return {
            "greeting": "Good evening",
            "message": "Perfect weather for exploring today.",

            "ai_pick": {
                "title": "Monastyrskyi Island",
                "reason": "Beautiful sunset and calm atmosphere today.",
                "score": 9.8
            },

            "mission": {
                "title": "Visit one new place",
                "xp": 50
            },

            "achievement": {
                "title": "First Steps",
                "emoji": "🌱"
            }
        }