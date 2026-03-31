set dotenv-load := true

module_url := `head -n 1 go.mod | cut -d ' ' -f 2`
export CGO_CXXFLAGS := "-std=c++17"
export PKG_CONFIG_PATH := justfile_directory() + "/6.10.2/macos/lib/pkgconfig"

test:
    echo $PKG_CONFIG_PATH
    go test ./...

updsum SEMVER:
	sleep 3
	curl https://sum.golang.org/lookup/{{module_url}}@{{SEMVER}}

tag-push SEMVER:
	git tag {{SEMVER}}
	git push origin {{SEMVER}}

commit-push SEMVER:
    git add . ; git commit -m "release: {{SEMVER}}"
    git tag {{SEMVER}}
    git push ; git push origin {{SEMVER}}

release SEMVER: test (commit-push SEMVER) (updsum SEMVER)
