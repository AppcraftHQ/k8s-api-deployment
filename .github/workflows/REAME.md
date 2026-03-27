## Notes

### 1. If you do not add tags to the git commands, the CI/CD WILL NOT build the Docker image.

# 1. Make your changes and commit.

```bash git add .
git commit -m "Add new features"
```

# 2. Create a tag

```bash
git tag v1.0.0
```

# 3. Push commits AND tag

```bash
git push origin main --tags
```

#### Using `bash git push origin main --tags` is for the Go backend changes when a new image is built. Do not use --tags when doing when you're in the /infra directory.

# 4. Here is my current deployment workflow here:

1. add, commit & create git tag v1.0.xx

2. git push origin main --tags
   ↓
3. CI: test → lint → build image
   ↓
4. CI: update values-dev.yaml automatically
   ↓
5. ArgoCD detects change (~3 min)
   ↓
6. Deployed! 🚀
   ↓
7. You pull from Git to update values-dev automatically
