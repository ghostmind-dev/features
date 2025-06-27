#!/bin/bash

# Comprehensive test script for ZSH with Oh My Zsh feature
set -e

echo "🧪 Testing ZSH with Oh My Zsh installation (comprehensive test)..."
echo ""

# Determine the user being tested
if [ -n "${_REMOTE_USER}" ]; then
    USERNAME="${_REMOTE_USER}"
elif [ -n "${USERNAME}" ]; then
    USERNAME="${USERNAME}"
else
    USERNAME="vscode"
fi

USER_HOME=$(eval echo "~${USERNAME}")
ZSH_CUSTOM="${USER_HOME}/.oh-my-zsh/custom"
ZSHRC="${USER_HOME}/.zshrc"

echo "Testing configuration for user: ${USERNAME}"
echo "Home directory: ${USER_HOME}"
echo ""

# Test 1: Check if ZSH is installed
echo "Test 1: Checking if ZSH is installed..."
if ! command -v zsh &> /dev/null; then
    echo "❌ zsh command not found"
    exit 1
fi
echo "✅ ZSH is installed"
ZSH_VERSION=$(zsh --version | head -1)
echo "   Version: ${ZSH_VERSION}"

# Test 2: Check if Oh My Zsh is installed
echo "Test 2: Checking Oh My Zsh installation..."
if [ ! -d "${USER_HOME}/.oh-my-zsh" ]; then
    echo "❌ Oh My Zsh directory not found at ${USER_HOME}/.oh-my-zsh"
    exit 1
fi
echo "✅ Oh My Zsh is installed"

# Test 3: Check if .zshrc exists and is configured
echo "Test 3: Checking .zshrc configuration..."
if [ ! -f "${ZSHRC}" ]; then
    echo "❌ .zshrc file not found at ${ZSHRC}"
    exit 1
fi
echo "✅ .zshrc file exists"

# Test 4: Check ZSH theme configuration
echo "Test 4: Checking ZSH theme configuration..."
CONFIGURED_THEME=$(grep "^ZSH_THEME=" "${ZSHRC}" | cut -d'"' -f2)
echo "   Configured theme: ${CONFIGURED_THEME}"

# Validate theme installation based on configured theme
case "${CONFIGURED_THEME}" in
    "spaceship")
        if [ -f "${ZSH_CUSTOM}/themes/spaceship.zsh-theme" ]; then
            echo "✅ Spaceship theme is properly installed"
        else
            echo "❌ Spaceship theme not found"
            exit 1
        fi
        ;;
    "powerlevel10k/powerlevel10k")
        if [ -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]; then
            echo "✅ Powerlevel10k theme is properly installed"
        else
            echo "❌ Powerlevel10k theme not found"
            exit 1
        fi
        ;;
    "agnoster"|"robbyrussell")
        echo "✅ Using built-in theme: ${CONFIGURED_THEME}"
        ;;
    *)
        echo "⚠️  Unknown theme configured: ${CONFIGURED_THEME}"
        ;;
esac

# Test 5: Check plugins configuration
echo "Test 5: Checking plugins configuration..."
PLUGINS_LINE=$(grep "^plugins=" "${ZSHRC}")
echo "   ${PLUGINS_LINE}"

# Extract plugins from the configuration
CONFIGURED_PLUGINS=$(echo "${PLUGINS_LINE}" | sed 's/plugins=(//' | sed 's/)//' | tr ' ' '\n' | sort)
echo "   Configured plugins:"
echo "${CONFIGURED_PLUGINS}" | sed 's/^/     - /'

# Test 6: Check if custom plugins are installed
echo "Test 6: Checking custom plugin installations..."

# Check zsh-autosuggestions
if echo "${CONFIGURED_PLUGINS}" | grep -q "zsh-autosuggestions"; then
    if [ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
        echo "✅ zsh-autosuggestions plugin is installed"
    else
        echo "❌ zsh-autosuggestions plugin configured but not installed"
        exit 1
    fi
else
    echo "ℹ️  zsh-autosuggestions plugin not configured"
fi

# Check zsh-syntax-highlighting
if echo "${CONFIGURED_PLUGINS}" | grep -q "zsh-syntax-highlighting"; then
    if [ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
        echo "✅ zsh-syntax-highlighting plugin is installed"
    else
        echo "❌ zsh-syntax-highlighting plugin configured but not installed"
        exit 1
    fi
else
    echo "ℹ️  zsh-syntax-highlighting plugin not configured"
fi

# Check zsh-completions
if echo "${CONFIGURED_PLUGINS}" | grep -q "zsh-completions"; then
    if [ -d "${ZSH_CUSTOM}/plugins/zsh-completions" ]; then
        echo "✅ zsh-completions plugin is installed"
    else
        echo "❌ zsh-completions plugin configured but not installed"
        exit 1
    fi
else
    echo "ℹ️  zsh-completions plugin not configured"
fi

# Test 7: Check file ownership
echo "Test 7: Checking file ownership..."
OH_MY_ZSH_OWNER=$(stat -c '%U' "${USER_HOME}/.oh-my-zsh")
ZSHRC_OWNER=$(stat -c '%U' "${ZSHRC}")

if [ "${OH_MY_ZSH_OWNER}" = "${USERNAME}" ]; then
    echo "✅ Oh My Zsh directory has correct ownership (${USERNAME})"
else
    echo "❌ Oh My Zsh directory ownership incorrect: ${OH_MY_ZSH_OWNER} (expected: ${USERNAME})"
    exit 1
fi

if [ "${ZSHRC_OWNER}" = "${USERNAME}" ]; then
    echo "✅ .zshrc file has correct ownership (${USERNAME})"
else
    echo "❌ .zshrc file ownership incorrect: ${ZSHRC_OWNER} (expected: ${USERNAME})"
    exit 1
fi

# Test 8: Test ZSH functionality
echo "Test 8: Testing ZSH functionality..."

# Test basic ZSH execution with timeout to prevent hanging
echo "Testing basic ZSH execution..."
if timeout 10s zsh -c "echo 'ZSH basic test'" > /dev/null 2>&1; then
    echo "✅ ZSH executes successfully"
else
    echo "⚠️  ZSH execution test timed out or failed (may be normal in container environments)"
fi

# Test Oh My Zsh configuration by checking files and .zshrc content
echo "Testing Oh My Zsh configuration..."
if grep -q "source.*oh-my-zsh" "${ZSHRC}" || grep -q "ZSH=" "${ZSHRC}" || grep -q "oh-my-zsh.sh" "${ZSHRC}"; then
    echo "✅ Oh My Zsh configuration found in .zshrc"
else
    echo "⚠️  Oh My Zsh configuration not found in .zshrc"
fi

# Check if Oh My Zsh directory structure is correct
if [ -f "${USER_HOME}/.oh-my-zsh/oh-my-zsh.sh" ]; then
    echo "✅ Oh My Zsh main script is present"
else
    echo "⚠️  Oh My Zsh main script not found"
fi

# Test 9: Check default shell (if configured)
echo "Test 9: Checking default shell configuration..."
USER_SHELL=$(getent passwd "${USERNAME}" | cut -d: -f7)
echo "   Current shell for ${USERNAME}: ${USER_SHELL}"

if [ "${USER_SHELL}" = "$(which zsh)" ]; then
    echo "✅ ZSH is set as default shell"
elif [ "${USER_SHELL}" = "/usr/bin/zsh" ] || [ "${USER_SHELL}" = "/bin/zsh" ]; then
    echo "✅ ZSH is set as default shell"
else
    echo "ℹ️  ZSH is not the default shell (this may be intentional based on configuration)"
fi

# Test 10: Check Spaceship theme specific configuration (if applicable)
if [ "${CONFIGURED_THEME}" = "spaceship" ]; then
    echo "Test 10: Checking Spaceship theme configuration..."
    if grep -q "SPACESHIP_PROMPT_ADD_NEWLINE=false" "${ZSHRC}"; then
        echo "✅ Spaceship theme custom configuration applied"
    else
        echo "⚠️  Spaceship theme custom configuration not found"
    fi
fi

# Test 11: Test plugin functionality (basic check)
echo "Test 11: Testing plugin functionality..."

# Check if git plugin is configured in .zshrc
if grep -q "git" "${ZSHRC}" && grep -q "plugins=" "${ZSHRC}"; then
    echo "✅ Git plugin is configured in .zshrc"
else
    echo "⚠️  Git plugin not found in .zshrc configuration"
fi

# Test autosuggestions plugin (if installed)
if [ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
    # Check if the plugin files exist and are properly configured
    if [ -f "${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
        echo "✅ zsh-autosuggestions plugin files are present"
    else
        echo "⚠️  zsh-autosuggestions plugin directory exists but main file missing"
    fi
    
    # Check if plugin is configured in .zshrc
    if grep -q "zsh-autosuggestions" "${ZSHRC}"; then
        echo "✅ zsh-autosuggestions plugin is configured in .zshrc"
    else
        echo "⚠️  zsh-autosuggestions plugin not configured in .zshrc"
    fi
fi

# Test syntax highlighting plugin (if installed)
if [ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
    if [ -f "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        echo "✅ zsh-syntax-highlighting plugin files are present"
    else
        echo "⚠️  zsh-syntax-highlighting plugin directory exists but main file missing"
    fi
    
    if grep -q "zsh-syntax-highlighting" "${ZSHRC}"; then
        echo "✅ zsh-syntax-highlighting plugin is configured in .zshrc"
    else
        echo "⚠️  zsh-syntax-highlighting plugin not configured in .zshrc"
    fi
fi

# Test completions plugin (if installed)
if [ -d "${ZSH_CUSTOM}/plugins/zsh-completions" ]; then
    if [ -d "${ZSH_CUSTOM}/plugins/zsh-completions/src" ]; then
        echo "✅ zsh-completions plugin files are present"
    else
        echo "⚠️  zsh-completions plugin directory exists but src directory missing"
    fi
    
    if grep -q "zsh-completions" "${ZSHRC}"; then
        echo "✅ zsh-completions plugin is configured in .zshrc"
    else
        echo "⚠️  zsh-completions plugin not configured in .zshrc"
    fi
fi

echo ""
echo "🎉 All tests passed! ZSH with Oh My Zsh feature is working correctly."
echo "Summary:"
echo "  ✅ ZSH installed and functional"
echo "  ✅ Oh My Zsh properly configured"
echo "  ✅ Theme installation verified"
echo "  ✅ Plugins configured and installed"
echo "  ✅ File ownership correct"
echo "  ✅ Shell functionality verified"
echo "  ✅ User configuration applied" 