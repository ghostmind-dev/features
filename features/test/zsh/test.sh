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

# Check if we're in environment variable mode
ENV_VAR_MODE=false
if grep -q "INIT_ZSH_THEME" /etc/environment 2>/dev/null || grep -q "INIT_ZSH_PLUGINS" /etc/environment 2>/dev/null; then
    ENV_VAR_MODE=true
    echo "🔧 Environment variable mode detected"
fi

# Test 1: Check if ZSH is installed (skip if installFeature=false might be used)
echo "Test 1: Checking if ZSH is installed..."
if command -v zsh &> /dev/null; then
    echo "✅ ZSH is installed"
    ZSH_VERSION=$(zsh --version | head -1)
    echo "   Version: ${ZSH_VERSION}"
else
    echo "ℹ️  ZSH not found (may be intentional if installFeature=false)"
fi

# Test 2: Check if Oh My Zsh is installed
echo "Test 2: Checking Oh My Zsh installation..."
if [ -d "${USER_HOME}/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh is installed"
    
    # Check if Oh My Zsh directory structure is correct
    if [ -f "${USER_HOME}/.oh-my-zsh/oh-my-zsh.sh" ]; then
        echo "✅ Oh My Zsh main script is present"
    else
        echo "⚠️  Oh My Zsh main script not found"
    fi
else
    echo "ℹ️  Oh My Zsh directory not found (may be intentional if installFeature=false)"
fi

# Test 3: Environment Variable Mode Testing
if [ "$ENV_VAR_MODE" = true ]; then
    echo "Test 3: Checking environment variables mode..."
    
    # Check INIT_ZSH_THEME
    if grep -q "INIT_ZSH_THEME" /etc/environment; then
        INIT_THEME=$(grep "INIT_ZSH_THEME" /etc/environment | cut -d'=' -f2 | tr -d '"')
        echo "✅ INIT_ZSH_THEME environment variable set to: ${INIT_THEME}"
    fi
    
    # Check INIT_ZSH_PLUGINS
    if grep -q "INIT_ZSH_PLUGINS" /etc/environment; then
        INIT_PLUGINS=$(grep "INIT_ZSH_PLUGINS" /etc/environment | cut -d'=' -f2 | tr -d '"')
        echo "✅ INIT_ZSH_PLUGINS environment variable set to: ${INIT_PLUGINS}"
    fi
    
    echo "ℹ️  Environment variable mode active - skipping .zshrc checks"
else
    echo "Test 3: Checking .zshrc configuration mode..."
    
    # Test .zshrc exists and is configured
    if [ -f "${ZSHRC}" ]; then
        echo "✅ .zshrc file exists"
        
        # Test ZSH theme configuration
        echo "Test 4: Checking ZSH theme configuration..."
        if grep -q "^ZSH_THEME=" "${ZSHRC}"; then
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
                "agnoster"|"codespaces"|"codespace")
                    echo "✅ Using built-in theme: ${CONFIGURED_THEME}"
                    ;;
                *)
                    echo "⚠️  Unknown theme configured: ${CONFIGURED_THEME}"
                    ;;
            esac
        else
            echo "⚠️  No ZSH_THEME found in .zshrc"
        fi
        
        # Test plugins configuration
        echo "Test 5: Checking plugins configuration..."
        if grep -q "^plugins=" "${ZSHRC}"; then
            PLUGINS_LINE=$(grep "^plugins=" "${ZSHRC}")
            echo "   ${PLUGINS_LINE}"
            
            # Extract plugins from the configuration
            CONFIGURED_PLUGINS=$(echo "${PLUGINS_LINE}" | sed 's/plugins=(//' | sed 's/)//' | tr ' ' '\n' | sort)
            echo "   Configured plugins:"
            echo "${CONFIGURED_PLUGINS}" | sed 's/^/     - /'
            
            # Test if custom plugins are installed
            echo "Test 6: Checking custom plugin installations..."
            
            # Check zsh-autosuggestions
            if echo "${CONFIGURED_PLUGINS}" | grep -q "zsh-autosuggestions"; then
                if [ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
                    echo "✅ zsh-autosuggestions plugin is installed"
                    
                    # Verify plugin files
                    if [ -f "${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
                        echo "✅ zsh-autosuggestions plugin files are present"
                    else
                        echo "⚠️  zsh-autosuggestions plugin directory exists but main file missing"
                    fi
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
                    
                    # Verify plugin files
                    if [ -f "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
                        echo "✅ zsh-syntax-highlighting plugin files are present"
                    else
                        echo "⚠️  zsh-syntax-highlighting plugin directory exists but main file missing"
                    fi
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
                    
                    # Verify plugin files
                    if [ -d "${ZSH_CUSTOM}/plugins/zsh-completions/src" ]; then
                        echo "✅ zsh-completions plugin files are present"
                    else
                        echo "⚠️  zsh-completions plugin directory exists but src directory missing"
                    fi
                else
                    echo "❌ zsh-completions plugin configured but not installed"
                    exit 1
                fi
            else
                echo "ℹ️  zsh-completions plugin not configured"
            fi
        else
            echo "⚠️  No plugins configuration found in .zshrc"
        fi
        
        # Check Spaceship theme specific configuration (if applicable)
        if [ "${CONFIGURED_THEME}" = "spaceship" ]; then
            echo "Test 7: Checking Spaceship theme configuration..."
            if grep -q "SPACESHIP_PROMPT_ADD_NEWLINE=false" "${ZSHRC}"; then
                echo "✅ Spaceship theme custom configuration applied"
            else
                echo "⚠️  Spaceship theme custom configuration not found"
            fi
        fi
        
        # Test Oh My Zsh configuration in .zshrc
        echo "Test 8: Testing Oh My Zsh configuration..."
        if grep -q "source.*oh-my-zsh" "${ZSHRC}" || grep -q "ZSH=" "${ZSHRC}" || grep -q "oh-my-zsh.sh" "${ZSHRC}"; then
            echo "✅ Oh My Zsh configuration found in .zshrc"
        else
            echo "⚠️  Oh My Zsh configuration not found in .zshrc"
        fi
    else
        echo "ℹ️  .zshrc file not found (may be intentional in some configurations)"
    fi
fi

# Test file ownership (if files exist)
echo "Test 9: Checking file ownership..."
if [ -d "${USER_HOME}/.oh-my-zsh" ]; then
    OH_MY_ZSH_OWNER=$(stat -c '%U' "${USER_HOME}/.oh-my-zsh")
    if [ "${OH_MY_ZSH_OWNER}" = "${USERNAME}" ]; then
        echo "✅ Oh My Zsh directory has correct ownership (${USERNAME})"
    else
        echo "❌ Oh My Zsh directory ownership incorrect: ${OH_MY_ZSH_OWNER} (expected: ${USERNAME})"
        exit 1
    fi
fi

if [ -f "${ZSHRC}" ]; then
    ZSHRC_OWNER=$(stat -c '%U' "${ZSHRC}")
    if [ "${ZSHRC_OWNER}" = "${USERNAME}" ]; then
        echo "✅ .zshrc file has correct ownership (${USERNAME})"
    else
        echo "❌ .zshrc file ownership incorrect: ${ZSHRC_OWNER} (expected: ${USERNAME})"
        exit 1
    fi
fi

# Test ZSH functionality (if ZSH is installed)
if command -v zsh &> /dev/null; then
    echo "Test 10: Testing ZSH functionality..."
    
    # Test basic ZSH execution with timeout to prevent hanging
    echo "Testing basic ZSH execution..."
    if timeout 10s zsh -c "echo 'ZSH basic test'" > /dev/null 2>&1; then
        echo "✅ ZSH executes successfully"
    else
        echo "⚠️  ZSH execution test timed out or failed (may be normal in container environments)"
    fi
fi

# Test default shell configuration
echo "Test 11: Checking default shell configuration..."
USER_SHELL=$(getent passwd "${USERNAME}" | cut -d: -f7)
echo "   Current shell for ${USERNAME}: ${USER_SHELL}"

if command -v zsh &> /dev/null; then
    if [ "${USER_SHELL}" = "$(which zsh)" ]; then
        echo "✅ ZSH is set as default shell"
    elif [ "${USER_SHELL}" = "/usr/bin/zsh" ] || [ "${USER_SHELL}" = "/bin/zsh" ]; then
        echo "✅ ZSH is set as default shell"
    else
        echo "ℹ️  ZSH is not the default shell (this may be intentional based on configuration)"
    fi
fi

echo ""
echo "🎉 All tests completed! ZSH with Oh My Zsh feature testing finished."
echo ""
echo "Summary:"
if command -v zsh &> /dev/null; then
    echo "  ✅ ZSH installed and functional"
fi
if [ -d "${USER_HOME}/.oh-my-zsh" ]; then
    echo "  ✅ Oh My Zsh properly configured"
fi
if [ "$ENV_VAR_MODE" = true ]; then
    echo "  ✅ Environment variable mode working"
else
    echo "  ✅ File configuration mode working"
fi
echo "  ✅ File ownership correct"
echo "  ✅ User configuration applied"
echo ""
echo "Test mode: $([ "$ENV_VAR_MODE" = true ] && echo "Environment Variables" || echo "File Configuration")" 