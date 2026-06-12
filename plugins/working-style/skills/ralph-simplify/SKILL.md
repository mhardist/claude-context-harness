---
name: ralph-simplify
description: Aggressively simplify code, solutions, or approaches by stripping away all unnecessary complexity. Use when code is overengineered, solutions are convoluted, or you need a "what would a child do?" perspective. Triggers on "simplify this", "too complex", "overengineered", "ralph simplify", or explicit /ralph-simplify.
---

# Ralph Simplify

*"I'm a unitard!"* - Ralph Wiggum

Aggressive simplification through the lens of someone who doesn't understand why things need to be complicated. If Ralph can't understand it, it's too complex.

## Philosophy

Ralph doesn't do:
- Design patterns
- Premature optimization
- "What if" scenarios
- Enterprise architecture
- Abstract factories that create abstract factories

Ralph does:
- The obvious thing
- The simple thing
- The thing that works right now

**Core Principle**: If you can't explain it to Ralph, rewrite it until you can.

## The Simplification Protocol

### Step 1: The "What Does It Actually Do?" Test

```
Question: What does this code ACTUALLY do?
├─ Can explain in one sentence? → Good start
├─ Need multiple sentences? → Too complex
└─ Need a diagram? → "That's a paddlin'"
```

Strip to the absolute core purpose. Everything else is suspect.

### Step 2: The Complexity Audit

Identify and question EVERYTHING:

```yaml
complexity_red_flags:
  - "🚨 Abstraction layers > 2"
  - "🚨 Config files > 1"
  - "🚨 Generics/templates for single use case"
  - "🚨 Interfaces with one implementation"
  - "🚨 Factory patterns for simple objects"
  - "🚨 Dependency injection for 3 dependencies"
  - "🚨 Event systems for linear flows"
  - "🚨 'Extensibility' for things that won't extend"
  - "🚨 Caching before measuring"
  - "🚨 Microservices for monolith problems"
```

For each flag: "Why?" → No good answer? → DELETE.

### Step 3: The Ralph Reduction

Apply these transformations aggressively:

| Complex Pattern | Ralph Version |
|-----------------|---------------|
| Factory + Interface + Impl | Just the class |
| Strategy pattern (1 strategy) | if/else or just the code |
| Observer pattern (2 observers) | Direct function calls |
| Singleton service | Module-level variable |
| Dependency injection | Import and use |
| Config-driven behavior | Hardcode it |
| Generic<T> (one T ever) | Use the actual type |
| AbstractBaseClass | Delete, inline to child |
| Utils class with 2 methods | Inline the methods |
| Wrapper that only wraps | Use the wrapped thing |
| Service that calls one other service | Merge them |
| DTO that matches entity exactly | Use the entity |

### Step 4: The "Delete It" Game

For each piece of code, ask:

```
"What breaks if I delete this?"
├─ Nothing? → DELETE IT 🗑️
├─ Tests break? → Are tests testing real behavior?
├─ Types break? → Is the type necessary?
└─ Runtime breaks? → Okay, maybe keep it
```

Ralph's Rule: **When in doubt, delete it out.**

### Step 5: The Rewrite

If simplification isn't enough, rewrite from scratch with constraints:

```yaml
ralph_constraints:
  max_files: 1 (if possible)
  max_functions: 5
  max_lines_per_function: 20
  max_parameters: 3
  max_nesting_depth: 2
  max_imports: 5
  abstractions: 0
  design_patterns: 0
  comments_explaining_complexity: 0 (no complexity = no explanation needed)
```

## Simplification Examples

### Example 1: The Over-Abstracted Service

**Before** (Enterprise Brain):
```typescript
// config/injection.ts
// interfaces/IUserRepository.ts
// interfaces/IUserService.ts
// repositories/UserRepository.ts
// services/UserService.ts
// factories/UserServiceFactory.ts
// dto/UserDTO.ts
// mappers/UserMapper.ts

class UserService implements IUserService {
  constructor(
    @Inject('IUserRepository') private repo: IUserRepository,
    @Inject('IUserMapper') private mapper: IUserMapper,
    @Inject('ILogger') private logger: ILogger,
    @Inject('IConfig') private config: IConfig
  ) {}

  async getUser(id: string): Promise<UserDTO> {
    this.logger.info('Getting user', { id });
    const entity = await this.repo.findById(id);
    return this.mapper.toDTO(entity);
  }
}
```

**After** (Ralph Brain):
```typescript
// user.ts
async function getUser(id: string) {
  return await db.users.findById(id);
}
```

*"I'm helping!"*

### Example 2: The Config-Driven Monster

**Before**:
```yaml
# config/features.yml
# config/services.yml
# config/mappings.yml
# 47 environment variables
```

**After**:
```typescript
const API_URL = "https://api.example.com";
const MAX_RETRIES = 3;
```

*"I bent my configuration!"*

### Example 3: The Premature Optimization

**Before**:
```typescript
class CachedUserService {
  private cache = new LRUCache<string, User>({ max: 1000, ttl: 60000 });
  private bloomFilter = new BloomFilter(1000, 0.01);

  async getUser(id: string) {
    if (!this.bloomFilter.mightContain(id)) return null;
    let user = this.cache.get(id);
    if (!user) {
      user = await this.repo.findById(id);
      this.cache.set(id, user);
      this.bloomFilter.add(id);
    }
    return user;
  }
}
```

**After**:
```typescript
async function getUser(id: string) {
  return await db.users.findById(id);
}
// Add caching when you MEASURE it's slow. Not before.
```

*"The doctor said I wouldn't have so many cache misses if I stopped premature optimization!"*

## Ralph's Simplification Mantras

| Situation | Mantra |
|-----------|--------|
| Adding abstraction | "Will there EVER be a second implementation?" |
| Adding config | "Will this EVER change?" |
| Adding caching | "Is this ACTUALLY slow?" |
| Adding types | "Does TypeScript already know this?" |
| Adding validation | "Can this ACTUALLY be invalid here?" |
| Adding logging | "Will anyone EVER read this log?" |
| Adding comments | "Can the code just... say this?" |
| Adding tests | "Is this testing REAL behavior?" |

## Output Format

When simplifying, produce:

```markdown
## Ralph Simplification Report

### What I Found 🔍
- [List of complexity smells]

### What I Deleted 🗑️
- [Things removed with brief justification]

### What I Inlined 📥
- [Abstractions flattened]

### What I Hardcoded 🔨
- [Configs that became constants]

### The Result ✨
- Before: X files, Y lines, Z abstractions
- After: A files, B lines, 0 abstractions
- Ralph Rating: "I'm a [simplicity level]!"

### The New Code
[Simplified code here]
```

## Ralph Ratings

| Rating | Meaning |
|--------|---------|
| "I'm a unitard!" | Maximum simplicity achieved |
| "I'm learnding!" | Good simplification, minor complexity remains |
| "My cat's breath smells like cat food" | Some complexity justified, noted why |
| "I'm in danger" | Could not simplify without breaking things |

## When NOT to Simplify

Even Ralph knows some limits:

- 🛑 Security code (don't simplify auth/crypto)
- 🛑 Actual performance-critical paths (measured, not assumed)
- 🛑 Legal/compliance requirements
- 🛑 Genuine multi-tenant/multi-implementation needs
- 🛑 External API contracts

For these: "Principal Skinner said I'm not allowed to simplify this."

## Integration

```yaml
usage_patterns:
  standalone: "/ralph-simplify [file or code block]"
  with_context: "This feels overengineered, /ralph-simplify"
  targeted: "/ralph-simplify --focus [function/class name]"
  audit_only: "/ralph-simplify --audit" (report without changes)
```

## The Final Test

After simplification, ask:

> "Could Ralph understand this code?"

- Yes → Ship it
- No → Simplify more
- "What's a code?" → Perfect
